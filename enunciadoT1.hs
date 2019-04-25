{- 
  Linguagens de Programação, 2019/01, Turma B.
  Prof. Vander Alves
  
  Trabalho1
  
  MATHEUS RODRIGUES GUIMARAES - 15/0141661 - BCC
  GABRIEL CUNHA BESSA VIEIRA  - 16/0120811 - BCC

  **O trabalho somente pode ser realizado individualmente ou em dupla.
  
  **Prazo de entrega: até dia 24/04/2019, às 23:59h (hora de Brasília)
    O trabalho deve ser entregue por e-mail para a monitora, Annelise.
    E-mail da entrega: anneliseschulzz@gmail.com
    O assunto (subject) do e-mail de entrega do trabalho deve ser "LP-T1"
	O corpo do e-mail deve identificar os autores do trabalho, informando nome completo e matrícula.
	O anexo do e-mail deve conter apenas um arguivo, com extensão ".hs" contendo as respostas ao trabalho.
	Cada dia de atraso na entrega do trabalho implicará perda de 1 ponto na nota do mesmo. Após 3 dias 
	de atrasto, a nota será 0.
	
  ** Critérios de correção:
   Caso o arquivo não compile ou não seja interpretável devido a erros sintáticos, a nota será zero.
   Após verificada a ausência de erros sintáticos, cada questão será avaliada com relação à 
   correção com base em testes e inspeção.
	  
  **Enunicado do trabalho:
	  
UnBCare
                                      
O objetivo desse trabalho é fornecer apoio ao gerenciamento de medicamentos a serem administrados a um 
paciente. Segundo orientação médica, um paciente segue um plano de medicamentos, através do qual 
medicamentos são prescritos a partir de um horário inicial e seguindo uma grade horária. Cada medicamento 
tem um nome e uma quantidade de comprimidos associada. Com base nisso, um paciente pode tomar remédios 
seguindo o plano ou em caráter emergencial(SOS). Eventualmente, o paciente ou responsável irá comprar 
medicamentos, o que é feito num mercado em que farmácias oferecem determinados medicamentos a preços 
específicos. Um objetivo prático é diminuir o custo com a aquisição de medicamentos. Considerando a 
definição de tipos abaixo:
-}
import Data.List

type Nome = String
type Quantidade = Int
type HorarioProximo = Int
type HoraAtual = Int
type Horario = [Int]
type Medicamento = (Nome,Quantidade)
type Medicamentos = [Medicamento]
type Prescricao = (Nome,Horario,HorarioProximo)
type PlanoMedicamento = [Prescricao]

{- 
Defina as seguintes funções abaixo:

**QUESTÃO 1, valor 1,0 ponto**
Defina a função adicionarMedicamento que adiciona medicamento à lista de medicamentos em qualquer 
posição da lista de medicamentos.  Se o medicamento já existir na lista de medicamentos, então 
a sua quantidade deve ser atualizada na lista. O tipo da função adicionarMedicamento é o seguinte:
-}
adicionarMedicamento :: Medicamento -> Medicamentos -> Medicamentos 
adicionarMedicamento (nome, qtd) [] = (nome, qtd) : [] -- Retorna o elemento adicionado
adicionarMedicamento (nome, qtd) ((n, q):res)
    | nome == n     = (n, q + qtd) : res -- Altera a quantidade se o remedio ja existir
    | otherwise     = (n, q) : adicionarMedicamento (nome, qtd) res -- Adiciona o Medicamento à lista
    
{-
**QUESTÃO 2, valor 1,0 ponto**
Defina a função removerMedicamento que, a partir do nome de um medicamento e de uma lista de medicamentos,
retorna uma nova lista em que o medicamento com esse nome é removido da lista. Se o medicamento não 
existir, a lista original de medicamentos é retornada. O tipo da função removerMedicamento é o seguinte:
-}
removerMedicamento :: Nome -> Medicamentos -> Medicamentos
removerMedicamento _ []                 = [] -- Retorna a lista vazia
removerMedicamento nome ((n,q):res)
  | nome == n    = removerMedicamento nome res -- 
  | otherwise    = (n,q) : removerMedicamento nome res
{- 
**QUESTÃO 3, valor 0,5 ponto**
Defina a função consultarMedicamento que, a partir do nome de um medicamento e de uma lista de medicamentos,
retorna esse medicamento, ou seja, um par (Nome,Quantidade) com as informações desse medicamento.
Se o medicamento não existir, retorne o par ("",0). O tipo da função consultarMedicamento é o seguinte:
-}
consultarMedicamento :: Nome -> Medicamentos -> Medicamento
consultarMedicamento nome [] = ("",0)
consultarMedicamento nome ((n,q):res)
  | nome == n   = (n,q)
  | otherwise   = consultarMedicamento nome res
{- 
**QUESTÃO 4, valor 1,0 ponto**
Defina a função alterarMedicamento que, a partir de um medicamento e de uma lista de medicamentos,
retorna uma nova lista de medicamentos em que esse medicamento seja atualizado na lista de medicamentos.
Se o medicamento não existir, a lista orginal de medicamentos é retornada.
O tipo da função alterarMedicamento é o seguinte:
-}
alterarMedicamento :: Medicamento -> Medicamentos -> Medicamentos
alterarMedicamento (nome, qtd) [] = []
alterarMedicamento (nome, qtd) ((n, q):res)
  | nome == n   = (n, qtd) : res
  | otherwise   = (n,q) : alterarMedicamento (nome, qtd) res

{- 
**QUESTÃO 5, valor 1,0 ponto
Defina a função tomarMedicamentoSOS que, a partir do nome de um medicamento e de uma lista de medicamentos,
retorna uma nova lista de medicamentos em que a quantidade desse remédio é diminuída em uma unidade.
Se não existir medicamento com o nome fornecido, a lista orginal de medicamentos é retornada.
O tipo da função tomarMedicamentoSOS é o seguinte:
-}
tomarMedicamentoSOS  ::  Nome -> Medicamentos ->  Medicamentos
tomarMedicamentoSOS nome [] = []
tomarMedicamentoSOS nome ((n,q):res)
  | nome == n   = (n, q - 1) : res
  | otherwise   = (n, q) : tomarMedicamentoSOS nome res
{- 
**QUESTÃO 6, valor 1,0 ponto
Defina a função tomarMedicamentosHorario que, a partir  de um plano de medicamentos, de uma lista de 
medicamentos, e da hora atual, retorna um par com o plano e a lista de medicamentos atualizados. 
O comportamento da função deve ser tal que, no horário atual, o paciente tome todos os remédios 
eventualmente previstos para aquele horário. Isso resulta em que a quantidade desses medicamentos seja 
atualizada e em que o plano seja atualizado no sentido em que tais remedios sejam tomados no próximo 
horário previsto. O tipo da função tomarMedicamentosHorario é o seguinte:
-}
tomarMedicamentosHorario :: PlanoMedicamento -> Medicamentos -> HoraAtual -> (PlanoMedicamento,Medicamentos)
tomarMedicamentosHorario _ [] _ = ([("", [0], 0)], [])
tomarMedicamentosHorario p_plano p_medicamentos p_horaAtual = (planoFinal, medicamentosFinal)
  where
    medicamentosParaAtualizar = [nome | (nome,horarios,horaProx) <- p_plano, horaProx == p_horaAtual]
    planoFinal            = atualizarPlano p_plano p_horaAtual
    medicamentosFinal     = atualizarMedicamentos medicamentosParaAtualizar p_medicamentos

atualizarPlano :: PlanoMedicamento -> HoraAtual -> PlanoMedicamento
atualizarPlano [] _ = []
atualizarPlano ((nome, (p_horarios), horaProx):restoPlano) p_horaAtual
  | p_horaAtual == horaProx  = [(nome, (p_horarios), (atualizarHoraPlano p_horarios p_horaAtual))]++(atualizarPlano restoPlano p_horaAtual)
  | otherwise                = ((nome, (p_horarios), horaProx):(atualizarPlano restoPlano p_horaAtual))

atualizarMedicamentos :: [Nome] -> Medicamentos -> Medicamentos
atualizarMedicamentos [] p_medicamentos = p_medicamentos
atualizarMedicamentos (nomeMedicamentoAtual:restoNomeMedicamentos) p_medicamentos = atualizarMedicamentos restoNomeMedicamentos (tomarMedicamentoSOS nomeMedicamentoAtual p_medicamentos)

atualizarHoraPlano :: Horario -> HoraAtual -> HorarioProximo
atualizarHoraPlano [] _ = 0
atualizarHoraPlano (hr:restoHorario) p_atual
  | [hora | hora <- (hr:restoHorario), hora > p_atual] /= []   = minimum [hora | hora <- (hr:restoHorario), hora > p_atual]
  | otherwise                                                  = minimum (hr:restoHorario)  
{- 
**QUESTÃO 7, valor 1,0 ponto
Defina a função cadastrarAlarmes que, dado um plano de medicamento, retorna uma grade horária única 
crescentemente ordenada de todos os instantes em que o paciente deve tomar seus medicamentos.
O tipo da função cadastrarAlarmes é o seguinte:
-}                                               

removerDuplicado :: Eq a => [a] -> [a]
removerDuplicado [] = []
removerDuplicado (x:xs)   | x `elem` xs   = removerDuplicado xs
                | otherwise     = x : removerDuplicado xs

cadastrarAlarmes :: PlanoMedicamento -> Horario
cadastrarAlarmes [] = []
cadastrarAlarmes ((nome, horarios, horaProx):restoPlano)
  | length horarios > 1  = sort (removerDuplicado ((horarios++(cadastrarAlarmes restoPlano))))
  | otherwise            = horarios


{- 
**QUESTÃO 8, valor 1,0 ponto
Defina a função listarMedicamentosComprar que, sendo fornecida uma lista de medicamentos, retorna
uma lista dos medicamentos que precisam ser comprados, ou seja, aqueles cuja quantidade tenha zerado.
O tipo da função listarMedicamentosComprar é o seguinte:
-}                                                                       
listarMedicamentosComprar :: Medicamentos ->  Medicamentos
listarMedicamentosComprar [] = []
listarMedicamentosComprar ((nome, qtd):res)
    | qtd == 0     = (nome, qtd) : listarMedicamentosComprar res -- Verifica se a quantidade do remedio eh zero e salva para mostrar
    | otherwise    = listarMedicamentosComprar res -- Caso contrario faz a recursao


{- 
**QUESTÃO 9, valor 1,0 ponto
Defina a função comprarMedicamentosDias que, a partir de um plano de medicamentos, uma lista de 
medicamentos e um número de dias, deve retornar os medicamentos a serem comprados na quantidade exata
de acordo o plano de medicamentos para o número de dias informado e a partir de um estoque inicial de 
medicamentos especificado pela lista de medicamentos informado na chamada da função. 
O tipo da função comprarMedicamentosDias é o seguinte: 
-}
comprarMedicamentosDias ::  PlanoMedicamento -> Medicamentos -> Int -> Medicamentos
comprarMedicamentosDias [] _ _ = [] -- Plano de medicamentos vazio, retorna vazio
comprarMedicamentosDias _ [] _ = [] -- Medicamentos vazio, retorna vazio
comprarMedicamentosDias _ _ 0  = [] -- Dias igual a zero, retorna vazio
comprarMedicamentosDias ((nome, horario, horaProx):restoPlano) ((nomeMed, qtdMed):restoMedicamento) dias
  | nome == nomeMed && ((length horario * dias) - qtdMed) >= 0  = (nomeMed,((length horario * dias) - qtdMed)): comprarMedicamentosDias (restoPlano) (restoMedicamento) (dias) -- Se o nome do remedio tiver no plano, cal
  | nome == nomeMed && ((length horario * dias) - qtdMed) < 0  = (nomeMed,0): comprarMedicamentosDias (restoPlano) (restoMedicamento) (dias)
  | otherwise         = comprarMedicamentosDias (restoPlano) (restoMedicamento) (dias)

{- 
**QUESTÃO 10, valor 1,5 ponto
Defina a função comprarMedicamentosPreco que, a partir de uma lista de medicamentos e de um mercado
que consiste de uma lista de farmacias, retorne uma compra informando o nome da farmácia e o valor a 
ser gasto nela com a compra dos medicamentos. Essa farmácia deve ser tal que tenha todos os medicamentos 
na quantidade necessária para cada medicamento e que tenha o menor preço para a compra deles. 
O tipo da função comprarMedicamentosPreco é o seguinte: 


Considere que os coneitos de farmácia, mercado, e compra sejam conforme abaixo:

**Dica: determine as farmacias que tem todos os medicamentos requeridos na quantidade necessária; 
orce os medicamentos em cada uma dessas farmácias e, dentre estas, escolha a que oferece o menor 
preço pelo total dos medicamentos necessarios. Se existir mais de uma farmácia que ofereça esse 
mesmo preço total, escolha qualquer uma.
type Preco = Int
type Farmacia = (Nome,[(Medicamento,Preco)])
type Mercado = [Farmacia]
type Compra = (Preco, Nome)

comprarMedicamentosPreco :: Medicamentos -> Mercado -> Compra
-}

{- **QUESTÃO EXTRA 1, valendo 0,5 ponto a mais na lista.
Defina a função comprarMedicamentosPrecoFlex que, a partir de uma lista de medicamentos e de um
mercado, obtenha uma lista de compras. A compra agora é flexível. Uma farmácia não precisa ter 
todos o medicamentos. O objetivo contiua sendo  minimizar o custo total da compra, mas é possível 
que a compra seja em diferentes farmácias, comprando nelas os medicamentos mais baratos.
O tipo da função comprarMedicamentosPrecoFlex é o seguinte:

comprarMedicamentosPrecoFlex :: Medicamentos -> Mercado -> [CompraFlex]

onde 

type CompraFlex = (Preco, Nome, Medicamentos)

Dica: para cada medicamento, busque no mercado uma farmácia em que ele pode comprado pelo menor preço.
Considere chamar a função comprarMedicamentosPreco para ajudar nessa computação. Com isso, podemos 
saber para cada uma dessas farmácias quais são os remédios mais baratos que podemos comprar lá.
-}



{- **QUESTÃO EXTRA 2, valendo 0,5 ponto a mais. Somente uma questão extra será considerada.
Defina uma função careTaker que simule as ações requeridas por um cuidador para que ele(a) administre 
medicamentos de acordo com o plano de medicamentos e por uma certa quantidade de dias, a partir de um
estoque inicial de remédios.
O tipo da função careTaker é o seguinte:

careTaker :: PlanoMedicamento -> Int -> Medicamentos-> (PlanoMedicamento,Medicamentos)
-}