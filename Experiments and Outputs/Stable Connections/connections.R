library("sparql")
library("igraph")
 
#the first bit of this table makes a matrix like I used to, the second will create a node and edge csv. FIGHT
 
endpoint = "http://dbpedia.org/sparql"
 
query = "
 
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX : <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/property/>
PREFIX dbpedia: <http://dbpedia.org/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT DISTINCT ?name ?membername WHERE {
 
?person rdf:type dbpedia-owl:Wrestler .
?person rdfs:label ?name .
?member dbpprop:members ?person .
FILTER ( lang(?name) = 'en' ) .
?member rdfs:label ?membername .
FILTER ( lang(?membername) = 'en' ) .
 
}
"
 
qd <- SPARQL(endpoint,query)
df <- qd$results
 
query2 <-"
 
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX : <http://dbpedia.org/resource/>
PREFIX dbpedia2: <http://dbpedia.org/property/>
PREFIX dbpedia: <http://dbpedia.org/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dbo: <http://dbpedia.org/ontology/>
SELECT ?name ?membername WHERE {
 
?person rdf:type dbpedia-owl:Wrestler .
?person rdfs:label ?name .
?member dbpprop:formerMembers ?person .
FILTER ( lang(?name) = 'en' ) .
?member rdfs:label ?membername .
FILTER ( lang(?membername) = 'en' ) .
 
}
"
 
qd2 <- SPARQL(endpoint,query2)
df2 <- qd2$results
 
allrelationships<-rbind(df, df2)
write.csv(allrelationships, file = "allrelationships.csv")
cleanstables = read.csv("allrelationships-csv.csv")
cleanstables$x <- NULL
 
M = as.matrix( table(cleanstables) )
Mrow = M %*% t(M)
#Mcol = t(M) %*% M
write.csv(Mrow, "test.csv")
iMrow = graph.adjacency(Mrow, mode = "undirected")
E(iMrow)$weight <- count.multiple(iMrow)
iMrow <- simplify(iMrow)
iMrow = graph.adjacency(Mrow, mode = "undirected")
E(iMrow)$weight <- count.multiple(iMrow)
iMrow <- simplify(iMrow)
write.graph(iMrow, file="graph.graphml", format="graphml");