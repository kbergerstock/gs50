--[[
	StateMachine Class
	Author: Colton Ogden
	cogden@cs50.harvard.edu

	Code taken and edited from lessons in http://howtomakeanrpg.com

	Usage:

	States are only created as need, to save memory, reduce clean-up bugs and increase speed
	due to garbage collection taking longer with more data in memory.

	States are added with a string identifier and an intialisation function.
	It is expect the init function, when called, will return a table with
	Render, Update, Enter and Exit methods.

	gStateMachine = StateMachine {
			['MainMenu'] = function()
				return MainMenu()
			end,
			['InnerGame'] = function()
				return InnerGame()
			end,
			['GameOver'] = function()
				return GameOver()
			end,
	}
	gStateMachine:change("MainGame")

	Arguments passed into the Change function after the state name
	will be forwarded to the Enter function of the state being changed too.

	State identifiers should have the same name as the state table, unless there's a good
	reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
	straight forward.

	07/15/2018	Keith R. Bergerstock 
	Software , Test and Quality Engineer for over 30 years currently retired from Marquardt switches 
	I modified this code to eliminate a circular dependency. The sub classes derived from BaseState were 
	using a specific instance of the statemachine class ie gStatemachine a GLOBAL variable a very
	dangerous practise.

	For instance :
		Create the instance of gameStateMachine instead of  gStateMachine,(lexagraphically correct 
		you are creating a variable after all ), or simply declare local  gStateMachine both prefectly 
		reasonable.  Execute and see what happens. Or try running two flappy birds side by side as in
		a race for competing players. THis dependency would cause a rather spetacular result.
		Worse imagine what could happen if you tried to use multiple state machines (one for a robot, 
		one for a vision station. two for ideniticle work stations, one for a label and apply station ) 
		and someone hits the emergancy stop. well something like this https://around.com/ariane.html
	The modfications now allow the instance to be declared local and its data is encapusulated and hidden.
	To use you design  messahre packet where one key pair element is xxx.next
	by zsttomg the xxx.state to themrct desired state the core state macine will changge to the nre state
	ie msg.next = 'playstate' ther message packet can pass anytig youneed to  the imdivbual
	state.  any think not neeeded by that state is simply ignored. """ all your really doing is passing a 
	reference to a structure of referenxes """
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

StateMachine = Class{}
-- statemchine constructor
-- input a key , value pair list
-- where :
-- key == state name or index value
-- value = state class constructor
function StateMachine:init(states)
	self.states = states or {} -- [name] -> [a state constructor]
	-- must include an idle state, use an instance of the baseState for this
	self.current = 'idle'
end

--[[
	private function
	input a key,value paired list of parameters
	one of which must be next = 'nextState'
	it is passed without modification to the
	enter function where the state key is
	simply ignored
	krb	
]]
function StateMachine:_changeState(msg)
	self.states[self.current]:exit()		-- call the exit function of the okd state
	self.current = msg.next				-- change current state to new state
	self.states[self.current]:enter(msg)	-- call the enter function of the new state
end

-- public function
	-- change from idle to the initial state ie start it up
function StateMachine:run(msg, state)
	msg.next = state
end

-- inputs is a reference to an external object found in HID.lua
-- msg is the message packet for this application
-- dt is the time diferential from the last call to this function
function StateMachine:update(inputs, msg, dt)
	self.states[self.current]:update(inputs, msg, dt)
	if self.current ~= msg.next then
		self:_changeState(msg)
	end
	-- reset the hid inputs pressed
	inputs:reset()
end

function StateMachine:render(msg)
	self.states[self.current]:render(msg)
end