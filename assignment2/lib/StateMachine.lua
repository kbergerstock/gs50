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
	I modified this code to eliminate dependency of using an GLOBAL instance variable in state classes 
	derived from BaseState, (if you really need to do this it should be defined in BaseState as a static
	variable which the other classes inheirit) a very dangerous practise.
	For instance :
		Create the instance of gameStateMachine instead of  gStateMachine,(lexagraphically correct 
		you are creating a variable after all ), or simply declare local  gStateMachine both prefectly 
		reasonable.  Execute and see what happens.
		Worse imagine what could happen if you tried to use multiple state machines (one for a robot, 
		one for a vision station. two for identicle work stations, one for a label and apply station ) 
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

StateMachine = Class{}

function StateMachine:init(states)
	self.states = states or {} -- [name] -> [function that returns class representing a state]
	self.states['empty'] = BaseState
	self.current = 'empty'
	self.next = ''
end

-- private function
function StateMachine:changeState(ns)
	assert(self.states[ns.state])
	self.states[self.current]:exit()
	self.current = self.next
	self.states[self.current]:enter(enterParams)
end

-- public function
function StateMachine:run(params)
	self.next = params.state
	self:changeState(params)
end

function StateMachine:update(dt)
		local ns = self.states[self.current]:update(dt)
		if not ns then
			-- pass on return of a nil value
		else	
			self:changeState(ns)
		end
end

function StateMachine:render()
	self.states[self.current]:render()
end
