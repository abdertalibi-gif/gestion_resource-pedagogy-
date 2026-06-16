-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 01 juin 2026 à 01:35
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestion_ressources_pedagogiques`
--

-- --------------------------------------------------------

--
-- Structure de la table `affectations_modules`
--

CREATE TABLE `affectations_modules` (
  `id_affectation` int(11) NOT NULL,
  `id_professeur` int(11) NOT NULL,
  `id_module` int(11) NOT NULL,
  `annee_universitaire` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `affectations_modules`
--

INSERT INTO `affectations_modules` (`id_affectation`, `id_professeur`, `id_module`, `annee_universitaire`) VALUES
(1, 11, 1, '2025-2026'),
(2, 2, 1, '2025-2026'),
(3, 11, 3, '2025-2026'),
(4, 21, 4, '2025-2026'),
(5, 21, 170, '2025-2026'),
(6, 22, 167, '2025-2026'),
(7, 23, 185, '2025-2026'),
(8, 27, 186, '2025-2026'),
(9, 21, 183, '');

-- --------------------------------------------------------

--
-- Structure de la table `devoirs`
--

CREATE TABLE `devoirs` (
  `id_devoir` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `date_limite` datetime DEFAULT NULL,
  `nom_fichier` varchar(255) DEFAULT NULL,
  `chemin_fichier` varchar(500) DEFAULT NULL,
  `taille_fichier` bigint(20) DEFAULT 0,
  `date_creation` datetime DEFAULT current_timestamp(),
  `id_module` int(11) NOT NULL,
  `id_professeur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `devoirs`
--

INSERT INTO `devoirs` (`id_devoir`, `titre`, `description`, `date_limite`, `nom_fichier`, `chemin_fichier`, `taille_fichier`, `date_creation`, `id_module`, `id_professeur`) VALUES
(1, 'BASE DOENN', '', '2026-06-18 09:00:00', 'solution_traitement_images_1.pdf', '/assets/uploads/pdf/bc4c8571f2884861a7d1e4d37df314e3.pdf', 254251, '2026-05-26 17:46:16', 1, 11),
(2, 'pfe', '', '2026-07-07 09:00:00', NULL, NULL, 0, '2026-05-30 20:19:51', 170, 21),
(3, 'algo1', '', '2026-07-29 11:00:00', 'examan.pdf', '/assets/uploads/pdf/84c59d4ce9944a21b0a5a0abf287f505.pdf', 1398229, '2026-05-31 19:41:04', 185, 23),
(4, 'gggggg', '', '2223-02-13 22:12:00', NULL, NULL, 0, '2026-05-31 20:13:28', 183, 21);

-- --------------------------------------------------------

--
-- Structure de la table `favoris`
--

CREATE TABLE `favoris` (
  `id_favori` int(11) NOT NULL,
  `id_etudiant` int(11) NOT NULL,
  `id_ressource` int(11) NOT NULL,
  `date_ajout` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `favoris`
--

INSERT INTO `favoris` (`id_favori`, `id_etudiant`, `id_ressource`, `date_ajout`) VALUES
(5, 3, 9, '2026-05-26 23:05:30'),
(6, 3, 6, '2026-05-26 23:05:33'),
(9, 33, 11, '2026-05-31 02:41:20'),
(12, 24, 12, '2026-05-31 03:43:00'),
(25, 37, 24, '2026-05-31 19:06:07');

-- --------------------------------------------------------

--
-- Structure de la table `filieres`
--

CREATE TABLE `filieres` (
  `id_filiere` int(11) NOT NULL,
  `nom_filiere` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `filieres`
--

INSERT INTO `filieres` (`id_filiere`, `nom_filiere`, `description`) VALUES
(14, 'SMI', 'Mathématiques Informatique'),
(15, 'SMA', 'Mathématiques'),
(16, 'SMP', 'Physique'),
(17, 'SMC', 'Chimie'),
(18, 'SVI', 'Biologie'),
(19, 'STU', 'Géologie');

-- --------------------------------------------------------

--
-- Structure de la table `filiere_semestres`
--

CREATE TABLE `filiere_semestres` (
  `id` int(11) NOT NULL,
  `id_filiere` int(11) NOT NULL,
  `id_semestre` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `filiere_semestres`
--

INSERT INTO `filiere_semestres` (`id`, `id_filiere`, `id_semestre`) VALUES
(7, 1, 5),
(8, 1, 6),
(5, 5, 5),
(6, 5, 6),
(3, 11, 1),
(4, 11, 2),
(9, 12, 1),
(10, 12, 2),
(13, 13, 5),
(14, 13, 6);

-- --------------------------------------------------------

--
-- Structure de la table `historique_consultation`
--

CREATE TABLE `historique_consultation` (
  `id_historique` int(11) NOT NULL,
  `id_etudiant` int(11) NOT NULL,
  `id_ressource` int(11) NOT NULL,
  `date_consultation` timestamp NOT NULL DEFAULT current_timestamp(),
  `type_action` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `historique_consultation`
--

INSERT INTO `historique_consultation` (`id_historique`, `id_etudiant`, `id_ressource`, `date_consultation`, `type_action`) VALUES
(2, 3, 1, '2026-05-17 14:55:46', 'TELECHARGEMENT'),
(3, 3, 1, '2026-05-26 03:55:55', 'CONSULTATION'),
(4, 3, 1, '2026-05-26 03:55:58', 'TELECHARGEMENT'),
(5, 3, 1, '2026-05-26 03:56:10', 'CONSULTATION'),
(6, 3, 1, '2026-05-26 03:56:15', 'CONSULTATION'),
(7, 3, 1, '2026-05-26 03:56:18', 'TELECHARGEMENT'),
(8, 3, 1, '2026-05-26 03:58:17', 'CONSULTATION'),
(9, 3, 1, '2026-05-26 03:58:17', 'CONSULTATION'),
(10, 3, 1, '2026-05-26 03:58:18', 'CONSULTATION'),
(11, 3, 1, '2026-05-26 03:58:19', 'CONSULTATION'),
(12, 3, 1, '2026-05-26 03:58:20', 'CONSULTATION'),
(13, 3, 1, '2026-05-26 03:58:29', 'TELECHARGEMENT'),
(14, 3, 3, '2026-05-26 04:12:45', 'CONSULTATION'),
(15, 3, 3, '2026-05-26 04:12:48', 'TELECHARGEMENT'),
(16, 3, 3, '2026-05-26 04:12:52', 'CONSULTATION'),
(17, 3, 3, '2026-05-26 04:12:53', 'CONSULTATION'),
(18, 3, 2, '2026-05-26 04:13:02', 'TELECHARGEMENT'),
(19, 3, 1, '2026-05-26 04:13:08', 'TELECHARGEMENT'),
(20, 3, 1, '2026-05-26 04:13:12', 'CONSULTATION'),
(21, 3, 1, '2026-05-26 04:13:13', 'TELECHARGEMENT'),
(22, 13, 5, '2026-05-26 05:07:21', 'TELECHARGEMENT'),
(23, 3, 1, '2026-05-26 16:38:20', 'TELECHARGEMENT'),
(24, 12, 7, '2026-05-26 23:03:09', 'TELECHARGEMENT'),
(25, 12, 8, '2026-05-26 23:03:17', 'CONSULTATION'),
(26, 12, 8, '2026-05-26 23:03:19', 'TELECHARGEMENT'),
(27, 12, 8, '2026-05-26 23:03:28', 'CONSULTATION'),
(28, 12, 8, '2026-05-26 23:03:31', 'TELECHARGEMENT'),
(29, 12, 5, '2026-05-26 23:03:44', 'CONSULTATION'),
(30, 12, 5, '2026-05-26 23:03:45', 'TELECHARGEMENT'),
(31, 3, 9, '2026-05-26 23:04:57', 'CONSULTATION'),
(32, 3, 9, '2026-05-26 23:05:00', 'TELECHARGEMENT'),
(33, 3, 9, '2026-05-26 23:05:04', 'CONSULTATION'),
(34, 3, 9, '2026-05-26 23:05:06', 'CONSULTATION'),
(35, 3, 9, '2026-05-26 23:05:07', 'TELECHARGEMENT'),
(36, 3, 1, '2026-05-26 23:05:37', 'TELECHARGEMENT'),
(37, 3, 1, '2026-05-26 23:05:41', 'CONSULTATION'),
(38, 3, 1, '2026-05-26 23:05:47', 'CONSULTATION'),
(39, 3, 6, '2026-05-26 23:38:24', 'CONSULTATION'),
(40, 3, 6, '2026-05-26 23:38:25', 'TELECHARGEMENT'),
(41, 3, 9, '2026-05-26 23:39:02', 'CONSULTATION'),
(42, 3, 9, '2026-05-26 23:39:04', 'TELECHARGEMENT'),
(43, 33, 11, '2026-05-31 02:36:02', 'CONSULTATION'),
(44, 33, 11, '2026-05-31 02:36:05', 'TELECHARGEMENT'),
(45, 33, 11, '2026-05-31 02:36:14', 'TELECHARGEMENT'),
(46, 33, 11, '2026-05-31 02:39:06', 'CONSULTATION'),
(47, 33, 11, '2026-05-31 02:39:10', 'TELECHARGEMENT'),
(48, 33, 11, '2026-05-31 02:39:27', 'CONSULTATION'),
(49, 33, 11, '2026-05-31 02:39:30', 'CONSULTATION'),
(50, 33, 11, '2026-05-31 02:39:31', 'CONSULTATION'),
(51, 33, 11, '2026-05-31 02:39:33', 'TELECHARGEMENT'),
(52, 33, 11, '2026-05-31 02:41:22', 'TELECHARGEMENT'),
(53, 33, 11, '2026-05-31 02:43:20', 'CONSULTATION'),
(54, 33, 11, '2026-05-31 02:43:22', 'TELECHARGEMENT'),
(55, 26, 11, '2026-05-31 02:45:45', 'CONSULTATION'),
(56, 26, 11, '2026-05-31 02:45:46', 'TELECHARGEMENT'),
(57, 26, 12, '2026-05-31 02:52:52', 'CONSULTATION'),
(58, 26, 12, '2026-05-31 02:52:55', 'TELECHARGEMENT'),
(59, 26, 11, '2026-05-31 02:53:05', 'CONSULTATION'),
(60, 26, 11, '2026-05-31 02:53:06', 'TELECHARGEMENT'),
(61, 24, 11, '2026-05-31 02:53:42', 'CONSULTATION'),
(62, 24, 11, '2026-05-31 02:53:44', 'TELECHARGEMENT'),
(63, 24, 11, '2026-05-31 03:02:27', 'CONSULTATION'),
(64, 24, 11, '2026-05-31 03:02:28', 'TELECHARGEMENT'),
(65, 24, 11, '2026-05-31 03:03:51', 'CONSULTATION'),
(66, 24, 11, '2026-05-31 03:03:52', 'TELECHARGEMENT'),
(67, 24, 11, '2026-05-31 03:11:00', 'CONSULTATION'),
(68, 24, 11, '2026-05-31 03:11:02', 'TELECHARGEMENT'),
(69, 24, 11, '2026-05-31 03:11:09', 'CONSULTATION'),
(70, 24, 11, '2026-05-31 03:11:11', 'TELECHARGEMENT'),
(71, 24, 11, '2026-05-31 03:12:27', 'TELECHARGEMENT'),
(72, 24, 12, '2026-05-31 03:12:41', 'CONSULTATION'),
(73, 24, 12, '2026-05-31 03:12:42', 'TELECHARGEMENT'),
(74, 24, 12, '2026-05-31 03:12:56', 'CONSULTATION'),
(75, 24, 12, '2026-05-31 03:12:59', 'CONSULTATION'),
(76, 24, 12, '2026-05-31 03:13:01', 'CONSULTATION'),
(77, 24, 12, '2026-05-31 03:13:05', 'CONSULTATION'),
(78, 24, 12, '2026-05-31 03:13:06', 'CONSULTATION'),
(79, 24, 12, '2026-05-31 03:13:08', 'TELECHARGEMENT'),
(80, 24, 12, '2026-05-31 03:13:15', 'CONSULTATION'),
(81, 24, 12, '2026-05-31 03:13:19', 'TELECHARGEMENT'),
(82, 24, 11, '2026-05-31 03:14:59', 'CONSULTATION'),
(83, 24, 11, '2026-05-31 03:15:00', 'TELECHARGEMENT'),
(84, 24, 11, '2026-05-31 03:16:51', 'CONSULTATION'),
(85, 24, 11, '2026-05-31 03:16:52', 'TELECHARGEMENT'),
(86, 24, 11, '2026-05-31 03:18:01', 'CONSULTATION'),
(87, 24, 11, '2026-05-31 03:18:03', 'TELECHARGEMENT'),
(88, 24, 11, '2026-05-31 03:18:26', 'TELECHARGEMENT'),
(89, 24, 11, '2026-05-31 03:42:48', 'CONSULTATION'),
(90, 24, 11, '2026-05-31 03:42:49', 'TELECHARGEMENT'),
(91, 24, 12, '2026-05-31 03:43:01', 'TELECHARGEMENT'),
(92, 24, 11, '2026-05-31 03:54:11', 'CONSULTATION'),
(93, 24, 11, '2026-05-31 03:54:12', 'TELECHARGEMENT'),
(94, 24, 11, '2026-05-31 03:54:26', 'CONSULTATION'),
(95, 24, 11, '2026-05-31 03:56:40', 'CONSULTATION'),
(96, 24, 11, '2026-05-31 03:56:49', 'TELECHARGEMENT'),
(97, 24, 11, '2026-05-31 04:05:12', 'CONSULTATION'),
(98, 24, 11, '2026-05-31 04:05:14', 'TELECHARGEMENT'),
(99, 24, 11, '2026-05-31 04:05:27', 'CONSULTATION'),
(100, 24, 11, '2026-05-31 04:05:40', 'TELECHARGEMENT'),
(101, 24, 11, '2026-05-31 04:11:13', 'TELECHARGEMENT'),
(102, 24, 11, '2026-05-31 04:11:13', 'TELECHARGEMENT'),
(103, 24, 11, '2026-05-31 04:11:13', 'TELECHARGEMENT'),
(104, 24, 11, '2026-05-31 04:11:15', 'CONSULTATION'),
(105, 24, 11, '2026-05-31 04:11:15', 'CONSULTATION'),
(106, 24, 11, '2026-05-31 04:11:16', 'CONSULTATION'),
(107, 24, 11, '2026-05-31 04:11:16', 'TELECHARGEMENT'),
(108, 24, 11, '2026-05-31 04:22:39', 'CONSULTATION'),
(109, 24, 11, '2026-05-31 04:22:40', 'TELECHARGEMENT'),
(110, 24, 11, '2026-05-31 04:24:49', 'CONSULTATION'),
(111, 24, 11, '2026-05-31 04:28:49', 'CONSULTATION'),
(112, 24, 11, '2026-05-31 04:28:54', 'TELECHARGEMENT'),
(113, 24, 11, '2026-05-31 04:40:22', 'CONSULTATION'),
(114, 24, 11, '2026-05-31 04:40:24', 'TELECHARGEMENT'),
(115, 24, 12, '2026-05-31 04:55:17', 'CONSULTATION'),
(116, 24, 12, '2026-05-31 04:55:18', 'TELECHARGEMENT'),
(117, 24, 12, '2026-05-31 04:55:32', 'TELECHARGEMENT'),
(118, 26, 13, '2026-05-31 04:56:43', 'TELECHARGEMENT'),
(119, 26, 13, '2026-05-31 04:56:46', 'CONSULTATION'),
(120, 26, 13, '2026-05-31 04:56:50', 'TELECHARGEMENT'),
(121, 26, 12, '2026-05-31 04:57:00', 'CONSULTATION'),
(122, 26, 12, '2026-05-31 04:57:01', 'TELECHARGEMENT'),
(123, 24, 14, '2026-05-31 05:04:55', 'CONSULTATION'),
(124, 24, 14, '2026-05-31 05:04:57', 'TELECHARGEMENT'),
(125, 37, 24, '2026-05-31 19:04:17', 'CONSULTATION'),
(126, 37, 24, '2026-05-31 19:04:19', 'TELECHARGEMENT'),
(127, 37, 14, '2026-05-31 19:05:06', 'CONSULTATION'),
(128, 37, 14, '2026-05-31 19:05:09', 'CONSULTATION'),
(129, 37, 14, '2026-05-31 19:05:11', 'CONSULTATION'),
(130, 37, 26, '2026-05-31 19:05:29', 'CONSULTATION'),
(131, 37, 26, '2026-05-31 19:05:30', 'TELECHARGEMENT'),
(132, 37, 26, '2026-05-31 19:05:35', 'TELECHARGEMENT'),
(133, 37, 13, '2026-05-31 19:05:49', 'TELECHARGEMENT'),
(134, 37, 24, '2026-05-31 19:06:10', 'TELECHARGEMENT');

-- --------------------------------------------------------

--
-- Structure de la table `modules`
--

CREATE TABLE `modules` (
  `id_module` int(11) NOT NULL,
  `nom_module` varchar(150) NOT NULL,
  `code_module` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `id_semestre` int(11) NOT NULL,
  `id_filiere` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `modules`
--

INSERT INTO `modules` (`id_module`, `nom_module`, `code_module`, `description`, `id_semestre`, `id_filiere`) VALUES
(143, 'Analyse 1', 'SMI-S1-M1', 'Analyse 1', 1, 14),
(144, 'Algèbre 1', 'SMI-S1-M2', 'Algèbre 1', 1, 14),
(145, 'Algorithmique 1', 'SMI-S1-M3', 'Introduction programmation', 1, 14),
(146, 'Physique 1', 'SMI-S1-M4', 'Mécanique', 1, 14),
(147, 'Analyse 2', 'SMI-S2-M1', 'Analyse 2', 2, 14),
(148, 'Algèbre 2', 'SMI-S2-M2', 'Algèbre linéaire', 2, 14),
(149, 'Programmation 2', 'SMI-S2-M3', 'C / Python', 2, 14),
(150, 'Logique', 'SMI-S2-M4', 'Logique mathématique', 2, 14),
(151, 'Structures de données', 'SMI-S3-M1', 'Listes, piles, files', 3, 14),
(152, 'Système d’exploitation', 'SMI-S3-M2', 'Linux OS', 3, 14),
(153, 'Probabilités', 'SMI-S3-M3', 'Statistiques', 3, 14),
(154, 'Base de données', 'SMI-S4-M1', 'SQL & modélisation', 4, 14),
(155, 'Réseaux', 'SMI-S4-M2', 'Réseaux informatiques', 4, 14),
(156, 'Compilation', 'SMI-S5-M1', 'Compilation', 5, 14),
(157, 'POO', 'SMI-S5-M2', 'Java / C++', 5, 14),
(158, 'PFE', 'SMI-S6-M1', 'Projet fin d’études', 6, 14),
(159, 'Analyse 1', 'SMA-S1-M1', 'Analyse 1', 1, 15),
(160, 'Algèbre 1', 'SMA-S1-M2', 'Algèbre 1', 1, 15),
(161, 'Physique 1', 'SMA-S1-M3', 'Mécanique', 1, 15),
(162, 'Analyse 2', 'SMA-S2-M1', 'Analyse 2', 2, 15),
(163, 'Algèbre 2', 'SMA-S2-M2', 'Algèbre linéaire', 2, 15),
(164, 'Analyse 3', 'SMA-S3-M1', 'Analyse avancée', 3, 15),
(165, 'Algèbre 3', 'SMA-S3-M2', 'Algèbre avancée', 3, 15),
(166, 'Analyse numérique', 'SMA-S4-M1', 'Méthodes numériques', 4, 15),
(167, 'Probabilités', 'SMA-S4-M2', 'Stats', 4, 15),
(168, 'Topologie', 'SMA-S5-M1', 'Topologie', 5, 15),
(169, 'Équations diff', 'SMA-S5-M2', 'EDO', 5, 15),
(170, 'PFE', 'SMA-S6-M1', 'Projet fin d’études', 6, 15),
(171, 'Mécanique', 'SMP-S1-M1', 'Mécanique classique', 1, 16),
(172, 'Thermodynamique', 'SMP-S1-M2', 'Thermo', 1, 16),
(173, 'Électricité', 'SMP-S2-M1', 'Électricité', 2, 16),
(174, 'Optique', 'SMP-S2-M2', 'Optique', 2, 16),
(175, 'Électromagnétisme', 'SMP-S3-M1', 'EM', 3, 16),
(176, 'Mécanique avancée', 'SMP-S3-M2', 'Mécanique', 3, 16),
(177, 'Physique quantique', 'SMP-S4-M1', 'Quantique', 4, 16),
(178, 'Physique statistique', 'SMP-S4-M2', 'Statistique', 4, 16),
(179, 'Physique moderne', 'SMP-S5-M1', 'Relativité', 5, 16),
(180, 'PFE', 'SMP-S6-M1', 'Projet fin d’études', 6, 16),
(181, 'Chimie générale', 'SMC-S1-M1', 'Chimie générale', 1, 17),
(182, 'Physique 1', 'SMC-S1-M2', 'Physique', 1, 17),
(183, 'Chimie organique', 'SMC-S2-M1', 'Organique', 2, 17),
(184, 'Chimie analytique', 'SMC-S2-M2', 'Analyse chimique', 2, 17),
(185, 'Thermodynamique', 'SMC-S3-M1', 'Thermo chimique', 3, 17),
(186, 'Chimie minérale', 'SMC-S3-M2', 'Minérale', 3, 17),
(187, 'Chimie physique', 'SMC-S4-M1', 'Physique chimie', 4, 17),
(188, 'Spectroscopie', 'SMC-S4-M2', 'Analyse spectrale', 4, 17),
(189, 'Chimie avancée', 'SMC-S5-M1', 'Avancée', 5, 17),
(190, 'PFE', 'SMC-S6-M1', 'Projet fin d’études', 6, 17),
(191, 'Biologie cellulaire', 'SVI-S1-M1', 'Cellule', 1, 18),
(192, 'Chimie générale', 'SVI-S1-M2', 'Chimie', 1, 18),
(193, 'Biologie animale', 'SVI-S2-M1', 'Animal', 2, 18),
(194, 'Biologie végétale', 'SVI-S2-M2', 'Plantes', 2, 18),
(195, 'Génétique', 'SVI-S3-M1', 'ADN', 3, 18),
(196, 'Microbiologie', 'SVI-S3-M2', 'Microbes', 3, 18),
(197, 'Physiologie animale', 'SVI-S4-M1', 'Fonction animale', 4, 18),
(198, 'Physiologie végétale', 'SVI-S4-M2', 'Fonction plantes', 4, 18),
(199, 'Biotechnologie', 'SVI-S5-M1', 'Tech bio', 5, 18),
(200, 'PFE', 'SVI-S6-M1', 'Projet fin d’études', 6, 18),
(201, 'Géologie générale', 'STU-S1-M1', 'Géologie', 1, 19),
(202, 'Physique', 'STU-S1-M2', 'Physique', 1, 19),
(203, 'Minéralogie', 'STU-S2-M1', 'Minéraux', 2, 19),
(204, 'Paléontologie', 'STU-S2-M2', 'Fossiles', 2, 19),
(205, 'Sédimentologie', 'STU-S3-M1', 'Sédiments', 3, 19),
(206, 'Hydrologie', 'STU-S3-M2', 'Eau', 3, 19),
(207, 'Tectonique', 'STU-S4-M1', 'Plaques', 4, 19),
(208, 'Géochimie', 'STU-S4-M2', 'Chimie Terre', 4, 19),
(209, 'Géologie appliquée', 'STU-S5-M1', 'Applications', 5, 19),
(210, 'PFE', 'STU-S6-M1', 'Projet fin d’études', 6, 19),
(231, 'MTU', 'SMA-S1-M7', '', 5, 15);

-- --------------------------------------------------------

--
-- Structure de la table `reset_tokens`
--

CREATE TABLE `reset_tokens` (
  `id` int(11) NOT NULL,
  `utilisateur_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `date_creation` datetime NOT NULL DEFAULT current_timestamp(),
  `date_expiration` datetime NOT NULL,
  `utilise` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `ressources`
--

CREATE TABLE `ressources` (
  `id_ressource` int(11) NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `nom_fichier` varchar(255) NOT NULL,
  `chemin_fichier` varchar(500) NOT NULL,
  `taille_fichier` bigint(20) DEFAULT NULL,
  `date_upload` timestamp NOT NULL DEFAULT current_timestamp(),
  `visible` tinyint(1) DEFAULT 1,
  `id_professeur` int(11) NOT NULL,
  `id_module` int(11) NOT NULL,
  `id_type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `ressources`
--

INSERT INTO `ressources` (`id_ressource`, `titre`, `description`, `nom_fichier`, `chemin_fichier`, `taille_fichier`, `date_upload`, `visible`, `id_professeur`, `id_module`, `id_type`) VALUES
(13, 'JAVA', '', 'TP3_JSP.pdf', '/assets/uploads/pdf/11ea2a907af547199c4855d3856781b4.pdf', 1137952, '2026-05-31 04:56:23', 1, 21, 170, 1),
(14, 'pfe', '', 'bjonesn77-earth-8882368.png', '/assets/uploads/images/be3e48314499475daed9732ee23bcb58.png', 20688862, '2026-05-31 05:04:33', 1, 21, 170, 5),
(24, 'alins', '', 'Examen_S7_25.pdf', '/assets/uploads/pdf/6ae9a154a65548d2bdefa5d8ae2954ae.pdf', 85052, '2026-05-31 18:36:32', 1, 23, 185, 1),
(25, 'pfe', '', 'Examen_S7_25.zip', '/assets/uploads/documents/36c44056769449608c8667a4feaef0d0.zip', 81715, '2026-05-31 18:36:53', 1, 23, 185, 19),
(26, 'pfe', '', 'nnnnn.pdf', '/assets/uploads/pdf/29d9142de14a4d0ca821d24f3db1dbc9.pdf', 850737, '2026-05-31 18:40:26', 1, 23, 185, 3);

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE `roles` (
  `id_role` int(11) NOT NULL,
  `nom_role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `roles`
--

INSERT INTO `roles` (`id_role`, `nom_role`) VALUES
(1, 'ADMIN'),
(3, 'ETUDIANT'),
(2, 'PROFESSEUR');

-- --------------------------------------------------------

--
-- Structure de la table `semestres`
--

CREATE TABLE `semestres` (
  `id_semestre` int(11) NOT NULL,
  `nom_semestre` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `semestres`
--

INSERT INTO `semestres` (`id_semestre`, `nom_semestre`, `description`) VALUES
(1, 'S1', 'Semestre 1'),
(2, 'S2', 'Semestre 2'),
(3, 'S3', 'Semestre 3'),
(4, 'S4', 'Semestre 4'),
(5, 'S5', 'Semestre 5'),
(6, 'S6', 'Semestre 6');

-- --------------------------------------------------------

--
-- Structure de la table `soumissions`
--

CREATE TABLE `soumissions` (
  `id_soumission` int(11) NOT NULL,
  `id_etudiant` int(11) NOT NULL,
  `id_module` int(11) NOT NULL,
  `id_devoir` int(11) DEFAULT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `nom_fichier` varchar(255) NOT NULL,
  `chemin_fichier` varchar(500) NOT NULL,
  `taille_fichier` bigint(20) DEFAULT 0,
  `date_soumission` datetime DEFAULT current_timestamp(),
  `statut` varchar(20) DEFAULT 'EN_ATTENTE',
  `note` decimal(5,2) DEFAULT NULL,
  `commentaire` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `soumissions`
--

INSERT INTO `soumissions` (`id_soumission`, `id_etudiant`, `id_module`, `id_devoir`, `titre`, `description`, `nom_fichier`, `chemin_fichier`, `taille_fichier`, `date_soumission`, `statut`, `note`, `commentaire`) VALUES
(3, 33, 170, 2, 'pfe', '', 'TP3_JSP.pdf', '/assets/uploads/pdf/bdfddff135604f9d9b42a36dd28ead22.pdf', 1137952, '2026-05-30 20:36:06', 'EN_ATTENTE', NULL, NULL),
(4, 37, 183, 4, 'BASE DOENN', '', 'Examen_S7_25.pdf', '/assets/uploads/pdf/17d93521cda1464b87095b59314ab867.pdf', 85052, '2026-05-31 20:14:06', 'ACCEPTE', 18.00, 'hhhhhhhhhhhhhhhhh');

-- --------------------------------------------------------

--
-- Structure de la table `types_ressources`
--

CREATE TABLE `types_ressources` (
  `id_type` int(11) NOT NULL,
  `nom_type` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `types_ressources`
--

INSERT INTO `types_ressources` (`id_type`, `nom_type`) VALUES
(20, 'Excel'),
(1, 'PDF'),
(5, 'PPT'),
(3, 'TD'),
(4, 'TP'),
(2, 'VIDEO'),
(19, 'ZIP');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id_utilisateur` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `cne` varchar(20) DEFAULT NULL,
  `specialite` varchar(100) DEFAULT NULL,
  `statut_validation` varchar(20) NOT NULL DEFAULT 'EN_ATTENTE',
  `date_creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `statut` varchar(20) NOT NULL DEFAULT 'EN_ATTENTE',
  `id_role` int(11) NOT NULL,
  `id_filiere` int(11) DEFAULT NULL,
  `id_semestre` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id_utilisateur`, `nom`, `prenom`, `email`, `mot_de_passe`, `photo`, `telephone`, `cne`, `specialite`, `statut_validation`, `date_creation`, `statut`, `id_role`, `id_filiere`, `id_semestre`) VALUES
(1, 'ADMIN', 'SYSTEM', 'admin@gmail.com', 'admin123', NULL, '0600000000', NULL, NULL, 'ACCEPTE', '2026-05-14 22:42:12', 'ACCEPTE', 1, NULL, NULL),
(21, 'ali', 'ali', 'ali@gmail.com', '9AgJxDrLLDiM9bXeTyGxt+xZuvT6UQIFdlYUAIFszxD6ekjf8z8H1gfNX9KEIsNs', NULL, '06000000', NULL, 'info', 'ACCEPTE', '2026-05-29 21:10:49', 'ACCEPTE', 2, NULL, NULL),
(22, 'ali', 'reda', 'allli@gmail.com', 'vHlEPBYiLfshrRkX4a1RkBtPyR3Y0xvdCqJATEZOTqCtq2z26UV6Psnip1O+IShs', NULL, '06000000', NULL, NULL, 'EN_ATTENTE', '2026-05-30 02:11:58', 'ACCEPTE', 2, NULL, NULL),
(23, 'talibi', 'abder', 'alllli@gmail.com', 'O+qJKoph12FAzkmTopr+bh/eHi6CNUDGum5uwj5IE6VCq5WkBJZiWy675IRh16nf', NULL, '0605368543', NULL, NULL, 'EN_ATTENTE', '2026-05-30 02:12:27', 'ACCEPTE', 2, NULL, NULL),
(26, 'talibi', 'abder', 'talibi.abder@gmail.com', 'D196D+l8zTznE8vTsgHySoRF+M60pC7iOwVRRI0SnfxyX8XKhpeT1JDfIkAi09y1', NULL, '0605368543', 'UB111111', NULL, 'EN_ATTENTE', '2026-05-30 18:18:07', 'ACCEPTE', 3, 5, 5),
(37, 'abderrahim', 'abder', 'talibi@gmail.com', 'HKvWORNolSzDvnkKEnbCO0EYgbxeTeaXVlJJqrPnKhbq3TM/y2iwqmN4vcWPOsAE', NULL, '0605368543', 'UN1111111111', NULL, 'EN_ATTENTE', '2026-05-31 19:03:30', 'ACCEPTE', 3, 17, 2);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `affectations_modules`
--
ALTER TABLE `affectations_modules`
  ADD PRIMARY KEY (`id_affectation`),
  ADD KEY `fk_affectation_professeur` (`id_professeur`),
  ADD KEY `fk_affectation_module` (`id_module`);

--
-- Index pour la table `devoirs`
--
ALTER TABLE `devoirs`
  ADD PRIMARY KEY (`id_devoir`),
  ADD KEY `id_module` (`id_module`),
  ADD KEY `id_professeur` (`id_professeur`);

--
-- Index pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD PRIMARY KEY (`id_favori`),
  ADD KEY `fk_favori_etudiant` (`id_etudiant`),
  ADD KEY `fk_favori_ressource` (`id_ressource`);

--
-- Index pour la table `filieres`
--
ALTER TABLE `filieres`
  ADD PRIMARY KEY (`id_filiere`);

--
-- Index pour la table `filiere_semestres`
--
ALTER TABLE `filiere_semestres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_filiere_semestre` (`id_filiere`,`id_semestre`),
  ADD KEY `id_semestre` (`id_semestre`);

--
-- Index pour la table `historique_consultation`
--
ALTER TABLE `historique_consultation`
  ADD PRIMARY KEY (`id_historique`),
  ADD KEY `fk_historique_etudiant` (`id_etudiant`),
  ADD KEY `fk_historique_ressource` (`id_ressource`);

--
-- Index pour la table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id_module`),
  ADD UNIQUE KEY `code_module` (`code_module`),
  ADD KEY `fk_module_semestre` (`id_semestre`),
  ADD KEY `fk_module_filiere` (`id_filiere`);

--
-- Index pour la table `reset_tokens`
--
ALTER TABLE `reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_utilisateur` (`utilisateur_id`),
  ADD KEY `idx_expiration` (`date_expiration`);

--
-- Index pour la table `ressources`
--
ALTER TABLE `ressources`
  ADD PRIMARY KEY (`id_ressource`),
  ADD KEY `fk_ressource_professeur` (`id_professeur`),
  ADD KEY `fk_ressource_module` (`id_module`),
  ADD KEY `fk_ressource_type` (`id_type`);

--
-- Index pour la table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_role`),
  ADD UNIQUE KEY `nom_role` (`nom_role`);

--
-- Index pour la table `semestres`
--
ALTER TABLE `semestres`
  ADD PRIMARY KEY (`id_semestre`);

--
-- Index pour la table `soumissions`
--
ALTER TABLE `soumissions`
  ADD PRIMARY KEY (`id_soumission`),
  ADD KEY `fk_soumission_etudiant` (`id_etudiant`),
  ADD KEY `fk_soumission_module` (`id_module`),
  ADD KEY `fk_soumission_devoir` (`id_devoir`);

--
-- Index pour la table `types_ressources`
--
ALTER TABLE `types_ressources`
  ADD PRIMARY KEY (`id_type`),
  ADD UNIQUE KEY `nom_type` (`nom_type`);

--
-- Index pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id_utilisateur`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `cne` (`cne`),
  ADD KEY `fk_utilisateur_role` (`id_role`),
  ADD KEY `fk_utilisateur_filiere` (`id_filiere`),
  ADD KEY `fk_utilisateur_semestre` (`id_semestre`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `affectations_modules`
--
ALTER TABLE `affectations_modules`
  MODIFY `id_affectation` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `devoirs`
--
ALTER TABLE `devoirs`
  MODIFY `id_devoir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `favoris`
--
ALTER TABLE `favoris`
  MODIFY `id_favori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `filieres`
--
ALTER TABLE `filieres`
  MODIFY `id_filiere` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `filiere_semestres`
--
ALTER TABLE `filiere_semestres`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `historique_consultation`
--
ALTER TABLE `historique_consultation`
  MODIFY `id_historique` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT pour la table `modules`
--
ALTER TABLE `modules`
  MODIFY `id_module` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=232;

--
-- AUTO_INCREMENT pour la table `reset_tokens`
--
ALTER TABLE `reset_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `ressources`
--
ALTER TABLE `ressources`
  MODIFY `id_ressource` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `id_role` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `semestres`
--
ALTER TABLE `semestres`
  MODIFY `id_semestre` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `soumissions`
--
ALTER TABLE `soumissions`
  MODIFY `id_soumission` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `types_ressources`
--
ALTER TABLE `types_ressources`
  MODIFY `id_type` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id_utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `devoirs`
--
ALTER TABLE `devoirs`
  ADD CONSTRAINT `devoirs_ibfk_1` FOREIGN KEY (`id_module`) REFERENCES `modules` (`id_module`) ON DELETE CASCADE,
  ADD CONSTRAINT `devoirs_ibfk_2` FOREIGN KEY (`id_professeur`) REFERENCES `utilisateurs` (`id_utilisateur`) ON DELETE CASCADE;

--
-- Contraintes pour la table `favoris`
--
ALTER TABLE `favoris`
  ADD CONSTRAINT `fk_favori_etudiant` FOREIGN KEY (`id_etudiant`) REFERENCES `utilisateurs` (`id_utilisateur`),
  ADD CONSTRAINT `fk_favori_ressource` FOREIGN KEY (`id_ressource`) REFERENCES `ressources` (`id_ressource`);

--
-- Contraintes pour la table `filiere_semestres`
--
ALTER TABLE `filiere_semestres`
  ADD CONSTRAINT `filiere_semestres_ibfk_1` FOREIGN KEY (`id_filiere`) REFERENCES `filieres` (`id_filiere`) ON DELETE CASCADE,
  ADD CONSTRAINT `filiere_semestres_ibfk_2` FOREIGN KEY (`id_semestre`) REFERENCES `semestres` (`id_semestre`) ON DELETE CASCADE;

--
-- Contraintes pour la table `historique_consultation`
--
ALTER TABLE `historique_consultation`
  ADD CONSTRAINT `fk_historique_etudiant` FOREIGN KEY (`id_etudiant`) REFERENCES `utilisateurs` (`id_utilisateur`),
  ADD CONSTRAINT `fk_historique_ressource` FOREIGN KEY (`id_ressource`) REFERENCES `ressources` (`id_ressource`);

--
-- Contraintes pour la table `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `fk_module_filiere` FOREIGN KEY (`id_filiere`) REFERENCES `filieres` (`id_filiere`),
  ADD CONSTRAINT `fk_module_semestre` FOREIGN KEY (`id_semestre`) REFERENCES `semestres` (`id_semestre`);

--
-- Contraintes pour la table `reset_tokens`
--
ALTER TABLE `reset_tokens`
  ADD CONSTRAINT `fk_reset_token_user` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id_utilisateur`) ON DELETE CASCADE;

--
-- Contraintes pour la table `ressources`
--
ALTER TABLE `ressources`
  ADD CONSTRAINT `fk_ressource_module` FOREIGN KEY (`id_module`) REFERENCES `modules` (`id_module`),
  ADD CONSTRAINT `fk_ressource_professeur` FOREIGN KEY (`id_professeur`) REFERENCES `utilisateurs` (`id_utilisateur`),
  ADD CONSTRAINT `fk_ressource_type` FOREIGN KEY (`id_type`) REFERENCES `types_ressources` (`id_type`);

--
-- Contraintes pour la table `soumissions`
--
ALTER TABLE `soumissions`
  ADD CONSTRAINT `fk_soumission_devoir` FOREIGN KEY (`id_devoir`) REFERENCES `devoirs` (`id_devoir`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_soumission_etudiant` FOREIGN KEY (`id_etudiant`) REFERENCES `utilisateurs` (`id_utilisateur`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_soumission_module` FOREIGN KEY (`id_module`) REFERENCES `modules` (`id_module`) ON DELETE CASCADE,
  ADD CONSTRAINT `soumissions_ibfk_1` FOREIGN KEY (`id_devoir`) REFERENCES `devoirs` (`id_devoir`) ON DELETE SET NULL;

--
-- Contraintes pour la table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD CONSTRAINT `fk_utilisateur_filiere` FOREIGN KEY (`id_filiere`) REFERENCES `filieres` (`id_filiere`),
  ADD CONSTRAINT `fk_utilisateur_role` FOREIGN KEY (`id_role`) REFERENCES `roles` (`id_role`),
  ADD CONSTRAINT `fk_utilisateur_semestre` FOREIGN KEY (`id_semestre`) REFERENCES `semestres` (`id_semestre`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
