# Etapa 1: Compilación
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copiar el pom y descargar dependencias (esto ahorra tiempo en futuras compilaciones)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el código fuente y generar el JAR
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagen de ejecución
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copiamos el JAR generado desde la etapa 'build'
# Nota: Asegúrate de que el nombre del jar coincida, usualmente es artifactId-version.jar
COPY --from=build /app/target/*.jar app.jar

# Exponemos el puerto del microservicio
EXPOSE 8990

# Comando para arrancar
ENTRYPOINT ["java", "-jar", "app.jar"]