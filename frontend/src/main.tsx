import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const qc = new QueryClient()

function Home() {
  return <div>
    <h1>WildTrace</h1>
    <ul>
      <li><Link to="/trace/sample">Consumer trace</Link></li>
    </ul>
  </div>
}

function Trace() {
  return <div>Trace page placeholder</div>
}

const App = () => (
  <QueryClientProvider client={qc}>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home/>}/>
        <Route path="/trace/:qrId" element={<Trace/>}/>
      </Routes>
    </BrowserRouter>
  </QueryClientProvider>
)

createRoot(document.getElementById('root')!).render(<App/>)
