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
		To use you design a  message packet where one key pair element is xxx.next
		by setting the xxx.state to the desired state the core state machine will change to the new state
		ie msg.next = 'playstate'. The message packet can pass any data that is needed to the indivual
		states.  Any data not neeeded by a particular state is simply ignored.

		NEW CONCEPT - 2019.01.15 -  the statemachine only acts on variables and functions in the message packet.
		this enables coorperative multitasking of multiple state machines.

]]

-- luacheck: allow_defined,no unused
-- luacheck: globals Class BaseState

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

require 'lib/BaseState'
require 'lib/message'

StateMachine = Class{}
-- statemchine constructor
function StateMachine:init() end

--[[
	populate the state list in msg with key , value pairs of
	state identifier, state constructor
	krb
]]

-- change from idle to the initial state ie start it up
function StateMachine:run(msg, state)
	msg.Change(state)
end

-- state machine engine
-- msg is the message packet for this instance
-- dt is the time diferential from the last call to this function
function StateMachine:update(msg, dt)
	msg.states[msg.getCurrent()]:update(msg, dt)
	if msg.getCurrent() ~= msg.getNext() and msg.states[msg.getNext()] then
		msg.states[msg.getCurrent()]:exit(msg)	--call the exit function of the old state
		msg.advanceState()						-- change current state to new state
		msg.states[msg.getCurrent()]:enter(msg)	-- call the enter function of the new state
	end
end

-- indirect calls
function StateMachine:handle_input(msg, input)
	msg.states[msg.getCurrent()]:handleInput(input, msg)
end

function StateMachine:render(msg)
	msg.states[msg.getCurrent()]:render(msg)
end
