import express from 'express'
import cors from 'cors'

const app = express()
app.use(cors())
app.use(express.json())

let todos = []
let nextId = 1

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

app.get('/api/todos', (req, res) => {
  res.json(todos)
})

app.post('/api/todos', (req, res) => {
  const { title } = req.body
  if (!title) {
    return res.status(400).json({ error: 'Title is required' })
  }
  const todo = { id: nextId++, title, completed: false }
  todos.push(todo)
  res.status(201).json(todo)
})

app.put('/api/todos/:id', (req, res) => {
  const id = parseInt(req.params.id)
  const todo = todos.find(t => t.id === id)
  if (!todo) {
    return res.status(404).json({ error: 'Todo not found' })
  }
  todo.completed = !todo.completed
  res.json(todo)
})

app.delete('/api/todos/:id', (req, res) => {
  const id = parseInt(req.params.id)
  const index = todos.findIndex(t => t.id === id)
  if (index === -1) {
    return res.status(404).json({ error: 'Todo not found' })
  }
  todos.splice(index, 1)
  res.status(204).send()
})

// 테스트에서 상태 초기화용
export function resetTodos() {
  todos = []
  nextId = 1
}

export default app
