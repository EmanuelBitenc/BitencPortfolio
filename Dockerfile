# Dockerfile
# Use uma imagem do Node.js como base
FROM node:18 AS build

# Defina o diretório de trabalho no contêiner
WORKDIR /usr/src/app

# Copie o package.json e o yarn.lock
COPY package.json yarn.lock ./

# Instale as dependências do projeto
RUN yarn install

# Copie o restante dos arquivos do projeto
COPY . .

# Construa o aplicativo para produção
RUN yarn build

# Inicie uma nova etapa para executar o aplicativo
FROM node:14

# Instale o pacote 'serve' globalmente
RUN yarn global add serve

# Copie os arquivos construídos da etapa de construção
COPY --from=build /usr/src/app/dist /app

# Exponha a porta que o aplicativo usará
EXPOSE 5000

# Comando para iniciar o aplicativo
CMD [ "serve", "-s", "app", "-l", "5000" ]