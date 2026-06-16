# 🐦 Flappy Sensor Bird

## 📚 Projeto Acadêmico

**Curso:** Sistemas para Internet
**Projeto em Grupo:** Desenvolvimento de Jogo Interativo utilizando Sensor Ultrassônico e Arduino

### 👨‍💻 Integrantes

* Michael Sobrinho
* Daniel Alves
* Raynna Almeida

---

# 📖 Descrição do Projeto

O **Flappy Sensor Bird** é uma adaptação do clássico jogo Flappy Bird, desenvolvida com o objetivo de integrar conceitos de programação, eletrônica embarcada e interação homem-máquina.

Diferentemente da versão tradicional, o controle do personagem não é realizado por teclado ou mouse. O jogador utiliza a movimentação da mão diante de um sensor ultrassônico conectado ao Arduino Uno para controlar o voo do pássaro.

O projeto foi desenvolvido utilizando:

* **Arduino IDE** para programação da placa Arduino Uno.
* **Processing** para criação da interface gráfica e lógica do jogo.
* **Sensor Ultrassônico HC-SR04** para captura da distância da mão do usuário.

---

# 🎯 Objetivos

* Aplicar conceitos de programação em tempo real.
* Integrar hardware e software em um sistema interativo.
* Desenvolver uma interface gráfica utilizando Processing.
* Trabalhar com comunicação serial entre Arduino e computador.
* Criar uma experiência de jogo utilizando sensores físicos.

---

# 🛠 Tecnologias Utilizadas

## Hardware

* Arduino Uno
* Sensor Ultrassônico HC-SR04
* Cabos Jumper
* Computador

## Software

* Arduino IDE
* Processing
* Biblioteca Serial do Processing

---

# ⚙ Funcionamento do Sistema

## 1. Captura da Distância

O sensor HC-SR04 mede continuamente a distância entre a mão do jogador e o sensor.

Quando a mão se afasta:

* O valor da distância aumenta.
* O pássaro sobe.

Quando a mão se aproxima:

* O valor da distância diminui.
* O pássaro desce.

---

## 2. Comunicação Serial

O Arduino envia continuamente a distância medida para o computador através da porta serial utilizando comunicação em **9600 baud**.

Exemplo de envio:

```cpp
Serial.println(smoothDistance);
```

---

## 3. Processamento dos Dados

O Processing recebe os valores enviados pelo Arduino e utiliza essas informações para atualizar a posição vertical do pássaro em tempo real.

```java
if (IncomingDistance > 10) {
    birdy -= gravity;
} else {
    birdy += gravity;
}
```

---

# 🔌 Ligações do Sensor HC-SR04

| Sensor HC-SR04 | Arduino Uno |
| -------------- | ----------- |
| VCC            | 5V          |
| GND            | GND         |
| TRIG           | Pino 11     |
| ECHO           | Pino 10     |

---

# 📄 Código Arduino

O Arduino é responsável por:

* Acionar o sensor ultrassônico.
* Calcular a distância em centímetros.
* Aplicar suavização nas leituras.
* Enviar os valores para o computador via Serial.

Principais recursos implementados:

* Leitura contínua do HC-SR04.
* Filtro de suavização para evitar oscilações.
* Descarte de leituras inválidas.
* Comunicação serial em tempo real.

---

# 🎮 Funcionalidades do Jogo

## Interface Inicial

* Tela de apresentação.
* Campo para digitação do nome do jogador.
* Botão para iniciar a partida.
* Ranking dos melhores jogadores.

## Mecânica de Jogo

* Controle por movimento da mão.
* Obstáculos dinâmicos (pipes).
* Sistema de pontuação.
* Colisão com obstáculos.
* Reinício da partida.

## Sistema de Ranking

O jogo mantém um ranking local com os 5 melhores jogadores.

Recursos:

* Registro do nome do jogador.
* Atualização automática da pontuação.
* Ordenação do ranking em tempo real.
* Exibição dos Top 5.

---

# 🚀 Estrutura do Projeto

```text
Flappy-Sensor-Bird/
│
├── Arduino/
│   └── FlappySensorArduino.ino
│
├── Processing/
│   └── FlappySensorBird.pde
│
├── README.md
│
└── Documentacao/
    └── Relatorio.pdf
```

---

# 📷 Fluxo de Funcionamento

```text
Movimento da mão
        ↓
Sensor HC-SR04
        ↓
Arduino Uno
        ↓
Comunicação Serial
        ↓
Processing
        ↓
Movimentação do pássaro
        ↓
Pontuação e Ranking
```

---

# 🏆 Resultados Obtidos

O projeto demonstrou com sucesso a integração entre hardware e software, permitindo controlar um jogo digital por meio de sensores físicos.

Entre os resultados alcançados:

* Comunicação serial estável.
* Controle responsivo do personagem.
* Interface gráfica funcional.
* Sistema de ranking implementado.
* Aplicação prática de conceitos de IoT e Sistemas Embarcados.

---

# 📌 Conclusão

O desenvolvimento do Flappy Sensor Bird permitiu aplicar conhecimentos de programação, eletrônica e desenvolvimento de interfaces gráficas em um projeto interdisciplinar. A utilização do sensor ultrassônico trouxe uma forma inovadora de interação com o jogo, demonstrando o potencial da integração entre Arduino e Processing para criação de aplicações interativas.

---

## 👥 Autores

**Michael Sobrinho**
**Daniel Alves**
**Raynna Almeida**

Projeto desenvolvido para fins acadêmicos no curso de Sistemas para Internet.
