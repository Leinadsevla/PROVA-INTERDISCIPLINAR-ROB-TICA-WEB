const int trigPin = 11;
const int echoPin = 10;

long duration;
int distance;

// suavização
int smoothDistance = 0;

void setup() {

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  Serial.begin(9600);
}

void loop() {

  // limpa trigger
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // dispara ultrassom
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // leitura
  duration = pulseIn(echoPin, HIGH, 15000);

  // converte para cm
  distance = duration * 0.034 / 2;

  // ignora leituras inválidas
  if (distance > 0 && distance < 80) {

    // suavização
    smoothDistance = (smoothDistance * 0.7) + (distance * 0.3);

    // envia SOMENTE o número
    Serial.println(smoothDistance);
  }

  // delay menor = resposta mais rápida
  delay(15);
}