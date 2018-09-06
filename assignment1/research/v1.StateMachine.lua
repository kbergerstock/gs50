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
	To use create a list of key,value pairs one of which should be ['state'] = 'nextState' and return the list ie
		local r = {}
			r['state'] = 'countdown'
			r['score'] = self.score
			return r
		or simply
			return {
				state = 'countdown',
				score = self.score
			}
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'class'
end

StateMachine = Class{}

-- statemchine constructor
-- input a key , value pair list
-- where :
-- key == state name or index value
-- value = state class constructor
function StateMachine:init(states)
	self.states = states or {} -- [name] -> [a state constructor]
	self.states['empty'] = BaseState()
	self.current = 'empty'
end

--[[
	private function
	input a key,value paired list of parameters
	one of which must be state = 'nextState'
	it is passed without modification to the
	enter function where the state key is
	simply ignored
	krb	
]]
function StateMachine:_changeState(ns)
	assert(self.states[ns.state])
	self.states[self.current]:exit()
	self.current = ns.state
	self.states[self.current]:enter(ns)
end

-- public function
function StateMachine:run(params)
	self:_changeState(params)
end

function StateMachine:update(dt)
		local ns = self.states[self.current]:update(dt)
		if not ns then
			-- pass on return of a nil value
		else	
			self:_changeState(ns)
		end
end

function StateMachine:render()
	self.states[self.current]:render()
end

