import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function EditarPerfil({ usuario, setUsuario }) {
  const navigate = useNavigate();
  
  // Estado inicial com os dados do usuário logado
  const [formData, setFormData] = useState({
    nome: usuario?.nome || '',
    email: usuario?.email || '',
    senha: usuario?.senha || '',
    marca: usuario?.veiculo?.marca || '',
    potencia: usuario?.veiculo?.potencia || '',
    bateriaAtual: usuario?.veiculo?.bateriaAtual || ''
  });
  
  const [mensagem, setMensagem] = useState({ texto: '', tipo: '' });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMensagem({ texto: 'Salvando alterações...', tipo: '' });

    // Estrutura atualizada conforme o seu modelo de dados
    const usuarioAtualizado = {
      ...usuario,
      nome: formData.nome,
      email: formData.email.toLowerCase().trim(),
      senha: formData.senha,
      veiculo: {
        marca: formData.marca,
        potencia: formData.potencia,
        bateriaAtual: parseInt(formData.bateriaAtual)
      }
    };

    try {
      // Envia os dados atualizados para o JSON Server
      const response = await fetch(`http://localhost:3000/usuarios/${usuario.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(usuarioAtualizado)
      });

      if (response.ok) {
        // Atualiza o cache do navegador e o estado global
        localStorage.setItem('usuarioLogado', JSON.stringify(usuarioAtualizado));
        setUsuario(usuarioAtualizado);
        
        setMensagem({ texto: 'Perfil atualizado com sucesso!', tipo: 'success' });
        setTimeout(() => {
          navigate('/');
        }, 1500);
      } else {
        throw new Error('Falha ao atualizar o perfil.');
      }
    } catch (error) {
      setMensagem({ texto: 'Erro de conexão com o servidor.', tipo: 'error' });
    }
  };

  return (
    <div style={{ maxWidth: '550px', margin: '20px auto', fontFamily: 'sans-serif' }}>
      <h2>Editar Perfil</h2>
      
      <form onSubmit={handleSubmit} style={{
        background: '#fff',
        padding: '24px',
        borderRadius: '8px',
        boxShadow: '0 2px 5px rgba(0,0,0,0.1)',
        display: 'flex',
        flexDirection: 'column',
        gap: '16px'
      }}>
        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>Nome:</label>
          <input 
            name="nome" 
            type="text" 
            value={formData.nome} 
            onChange={handleChange} 
            required 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>E-mail:</label>
          <input 
            name="email" 
            type="email" 
            value={formData.email} 
            onChange={handleChange} 
            required 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>Senha:</label>
          <input 
            name="senha" 
            type="password" 
            value={formData.senha} 
            onChange={handleChange} 
            required 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <h4 style={{ margin: '10px 0 0 0', borderBottom: '1px solid #ddd', paddingBottom: '8px', color: '#555' }}>
          Informações do Veículo
        </h4>

        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>Marca e Modelo:</label>
          <input 
            name="marca" 
            type="text" 
            value={formData.marca} 
            onChange={handleChange} 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>Potência (kW):</label>
          <input 
            name="potencia" 
            type="text" 
            value={formData.potencia} 
            onChange={handleChange} 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <div>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '4px' }}>Bateria Atual (%):</label>
          <input 
            name="bateriaAtual" 
            type="number" 
            value={formData.bateriaAtual} 
            onChange={handleChange} 
            style={{ width: '100%', padding: '8px', border: '1px solid #ccc', borderRadius: '4px' }}
          />
        </div>

        <button 
          type="submit" 
          style={{
            backgroundColor: '#2ecc71',
            color: '#fff',
            border: 'none',
            padding: '12px',
            borderRadius: '4px',
            fontWeight: 'bold',
            cursor: 'pointer',
            marginTop: '10px'
          }}
        >
          Salvar Alterações
        </button>

        {mensagem.texto && (
          <p style={{ color: mensagem.tipo === 'success' ? 'green' : 'red', fontWeight: 'bold', textAlign: 'center', margin: '0' }}>
            {mensagem.texto}
          </p>
        )}
      </form>
    </div>
  );
}