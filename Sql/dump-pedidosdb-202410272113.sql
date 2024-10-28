-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: pedidosdb
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `idx_nome` (`nome`),
  KEY `idx_cidade_uf` (`cidade`,`uf`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'João Silva','São Paulo','SP'),(2,'Maria Santos','Rio de Janeiro','RJ'),(3,'Pedro Oliveira','Belo Horizonte','MG'),(4,'Ana Souza','Curitiba','PR'),(5,'Carlos Lima','Salvador','BA'),(6,'Patricia Ferreira','Recife','PE'),(7,'Roberto Costa','Fortaleza','CE'),(8,'Sandra Rodrigues','Porto Alegre','RS'),(9,'José Pereira','Manaus','AM'),(10,'Fernanda Santos','Brasília','DF'),(11,'Miguel Ribeiro','Vitória','ES'),(12,'Luciana Alves','Natal','RN'),(13,'Ricardo Monteiro','João Pessoa','PB'),(14,'Amanda Cruz','Florianópolis','SC'),(15,'Bruno Cardoso','Goiânia','GO'),(16,'Cristina Lima','Belém','PA'),(17,'Daniel Soares','São Luís','MA'),(18,'Elena Castro','Maceió','AL'),(19,'Fábio Mendes','Teresina','PI'),(20,'Gabriela Dias','Campo Grande','MS');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `numero_pedido` int NOT NULL AUTO_INCREMENT,
  `data_emissao` date NOT NULL,
  `codigo_cliente` int NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `idx_data` (`data_emissao`),
  KEY `idx_cliente` (`codigo_cliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (2,'2024-10-27',1,7749.94),(3,'2024-10-27',9,559.98),(4,'2024-10-27',9,399.99);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_pedido` int NOT NULL,
  `codigo_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pedido` (`numero_pedido`),
  KEY `idx_produto` (`codigo_produto`),
  CONSTRAINT `pedidos_produtos_ibfk_1` FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos` (`numero_pedido`),
  CONSTRAINT `pedidos_produtos_ibfk_2` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (8,2,1,1,3999.99,3999.99),(9,2,2,1,2499.99,2499.99),(10,2,4,1,299.99,299.99),(11,2,6,1,599.99,599.99),(12,2,7,1,199.99,199.99),(13,2,8,1,149.99,149.99),(14,3,10,1,399.99,399.99),(15,3,11,1,159.99,159.99),(16,4,10,1,399.99,399.99);
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `calcular_valor_total_item` BEFORE INSERT ON `pedidos_produtos` FOR EACH ROW BEGIN
    SET NEW.valor_total = NEW.quantidade * NEW.valor_unitario;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `atualizar_valor_total_pedido` AFTER INSERT ON `pedidos_produtos` FOR EACH ROW BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT SUM(valor_total)
        FROM pedidos_produtos
        WHERE numero_pedido = NEW.numero_pedido
    )
    WHERE numero_pedido = NEW.numero_pedido;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(200) NOT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `idx_descricao` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Notebook Dell 15\"',3999.99),(2,'Smartphone Samsung Galaxy',2499.99),(3,'Monitor LG 24\"',899.99),(4,'Teclado Mecânico',299.99),(5,'Mouse Sem Fio',89.99),(6,'Impressora HP',599.99),(7,'Fone de Ouvido Bluetooth',199.99),(8,'Webcam HD',149.99),(9,'Pen Drive 32GB',49.99),(10,'HD Externo 1TB',399.99),(11,'Roteador Wi-Fi',159.99),(12,'Carregador Portátil',79.99),(13,'Cabo HDMI 2m',29.99),(14,'Adaptador USB-C',39.99),(15,'Caixa de Som Bluetooth',129.99),(16,'Suporte para Notebook',69.99),(17,'Kit Teclado e Mouse',149.99),(18,'Mousepad Gamer',45.99),(19,'Hub USB 4 Portas',59.99),(20,'Filtro de Linha',39.99);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'pedidosdb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-27 21:13:56
