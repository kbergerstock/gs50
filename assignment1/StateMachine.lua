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
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.states = states or {} -- [name] -> [function that returns class representing a stste]
	self.states['empty'] = BaseState
	self.current = 'empty'
	self.next = ''
end

-- private function
function StateMachine:changeState(enterParams)
	assert(self.states[self.next])
	self.states[self.current]:exit()
	self.current = self.next
	self.states[self.current]:enter(enterParams)
end

-- public function
function StateMachine:run(stateName)
	self.next = stateName
	self:changeState()
end

function StateMachine:update(dt)
		local ns = self.states[self.current]:update(dt)
		if not ns then
			-- pass on return of a nil value
		else	
			self.next = ns['state']
			self:changeState(ns)
		end
end

function StateMachine:render()
	self.states[self.current]:render()
end
