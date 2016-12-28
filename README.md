#Some Test on dotnetcore
============

#okay, a bootstrap for a testing project lib on .net core, runnning in a vagrant or a docker

#To run in vagrant
vagrant up
vagrant ssh
cd test/PrimeServices.Tests
dotnet restore
dotnet test

#To run in a docker
docker build -t foo . && docker run foo
