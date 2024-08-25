-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: 127.0.0.1:3311
-- Generation Time: Mar 21, 2022 at 03:05 PM
-- Server version: 8.0.26
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `placard`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `id` int unsigned NOT NULL,
  `bannable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bannable_id` bigint unsigned NOT NULL,
  `created_by_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by_id` bigint unsigned DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `expired_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int unsigned NOT NULL,
  `parent_id` int unsigned DEFAULT NULL,
  `order` int DEFAULT '1',
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_attributes` json DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `parent_id`, `order`, `name`, `slug`, `hash`, `extra_attributes`, `image`, `created_at`, `updated_at`) VALUES
(1, 0, 1, 'General', 'general', NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-04-15 07:07:06'),
(3, 1, NULL, 'test2', 'test2', NULL, NULL, NULL, '2021-12-20 07:37:35', '2021-12-20 07:37:35');

-- --------------------------------------------------------

--
-- Table structure for table `category_pricing_model`
--

CREATE TABLE IF NOT EXISTS `category_pricing_model` (
  `category_id` int DEFAULT NULL,
  `pricing_model_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category_pricing_model`
--

INSERT INTO `category_pricing_model` (`category_id`, `pricing_model_id`) VALUES
(1, 2),
(2, 2),
(2, 1),
(2, 3),
(1, 1),
(1, 3),
(3, 1),
(3, 2),
(3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `checkout_sessions`
--

CREATE TABLE IF NOT EXISTS `checkout_sessions` (
  `id` int unsigned NOT NULL,
  `user_id` int DEFAULT NULL,
  `listing_id` int DEFAULT NULL,
  `request` json DEFAULT NULL,
  `payment_provider_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `order_id` int DEFAULT NULL,
  `extra_attributes` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `checkout_sessions`
--

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int unsigned NOT NULL,
  `listing_id` int DEFAULT NULL,
  `seller_id` int DEFAULT NULL,
  `commenter_id` int DEFAULT NULL,
  `order_id` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `feedback` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT '1',
  `rate` double(15,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE IF NOT EXISTS `conversations` (
  `id` int unsigned NOT NULL,
  `user_one` int NOT NULL,
  `user_two` int NOT NULL,
  `status` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `user_one`, `user_two`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '1984-09-05 11:47:41', '2021-06-14 10:56:43'),
(2, 1, 2, 1, '2021-06-14 11:07:51', '2021-06-14 11:30:00'),
(3, 0, 1, 1, '2021-06-28 02:42:38', '2021-06-28 02:42:38'),
(4, 1, 3, 2, '2021-06-28 02:50:38', '2021-11-23 14:02:49'),
(5, 1, 1, 2, '2021-06-28 02:58:31', '2021-06-28 02:58:31'),
(6, 1, 5, 1, '2021-06-28 02:59:08', '2021-06-28 02:59:08'),
(7, 1, 4, 1, '2021-06-28 03:01:00', '2021-11-23 14:31:45'),
(8, 1, 1, 2, '2021-06-28 03:15:37', '2021-09-15 07:51:52'),
(9, 1, 8, 1, '2021-08-22 13:48:18', '2021-08-22 13:54:36'),
(10, 1, 1, 2, '2021-09-06 10:04:03', '2021-09-06 10:04:03'),
(11, 1, 1, 2, '2021-09-06 10:05:35', '2021-09-15 07:54:25'),
(12, 1, 1, 2, '2021-10-19 12:53:32', '2021-10-19 12:53:32'),
(13, 1, 1, 2, '2021-10-20 08:25:41', '2021-10-20 08:25:41'),
(14, 1, 1, 2, '2021-10-20 12:18:02', '2021-10-20 12:18:02'),
(15, 1, 1, 2, '2021-10-22 08:54:30', '2021-10-22 08:54:30'),
(16, 1, 1, 2, '2021-10-22 08:54:57', '2021-10-22 08:54:57'),
(17, 1, 1, 2, '2021-10-22 08:56:20', '2021-10-22 08:56:20'),
(18, 1, 1, 2, '2021-10-22 11:13:16', '2021-10-22 11:13:16'),
(19, 1, 1, 2, '2021-10-22 13:15:34', '2021-10-22 13:15:34'),
(20, 1, 1, 2, '2021-11-04 14:30:11', '2021-11-04 14:30:11'),
(21, 1, 1, 2, '2021-11-10 09:53:39', '2021-11-10 09:53:39'),
(22, 1, 1, 2, '2021-11-20 14:31:21', '2021-11-20 14:31:21'),
(23, 1, 1, 2, '2021-11-20 14:33:52', '2021-11-20 14:33:52'),
(24, 1, 1, 2, '2021-11-20 14:35:41', '2021-11-20 14:35:41'),
(25, 1, 1, 2, '2021-11-20 14:37:36', '2021-11-20 14:37:36'),
(26, 1, 1, 2, '2021-11-20 14:41:06', '2021-11-20 14:41:06'),
(27, 1, 1, 2, '2021-11-22 13:31:16', '2021-11-22 13:31:16'),
(28, 1, 1, 2, '2021-11-24 14:39:58', '2021-11-24 14:39:58'),
(29, 1, 1, 2, '2021-11-26 07:44:15', '2021-11-26 07:44:15'),
(30, 1, 1, 2, '2021-11-30 15:38:27', '2021-11-30 15:38:27'),
(31, 1, 1, 2, '2021-11-30 15:40:26', '2021-11-30 15:40:26'),
(32, 1, 1, 2, '2021-12-09 15:00:53', '2021-12-09 15:00:54'),
(33, 1, 1, 2, '2021-12-09 15:01:50', '2021-12-09 15:01:50'),
(34, 1, 1, 2, '2021-12-09 15:07:41', '2021-12-09 15:07:41'),
(35, 1, 1, 2, '2021-12-09 15:13:48', '2021-12-09 15:13:48'),
(36, 1, 1, 2, '2021-12-09 15:14:25', '2021-12-09 15:14:25'),
(37, 1, 1, 2, '2021-12-09 15:15:08', '2021-12-09 15:15:08'),
(38, 1, 1, 2, '2021-12-09 15:17:48', '2021-12-09 15:17:48'),
(39, 1, 1, 2, '2021-12-09 15:18:37', '2021-12-09 15:18:37'),
(40, 1, 1, 2, '2021-12-09 15:19:27', '2021-12-09 15:19:27'),
(41, 1, 1, 2, '2021-12-09 15:19:43', '2021-12-09 15:19:43'),
(42, 1, 1, 2, '2021-12-09 15:20:18', '2021-12-09 15:20:18'),
(43, 1, 1, 2, '2021-12-09 15:22:16', '2021-12-09 15:22:16'),
(44, 1, 1, 2, '2021-12-09 15:23:20', '2021-12-09 15:23:20'),
(45, 1, 1, 2, '2021-12-09 15:24:52', '2021-12-09 15:24:52'),
(46, 1, 1, 2, '2021-12-09 15:25:45', '2021-12-13 13:56:40'),
(47, 5, 5, 2, '2021-12-15 08:18:59', '2021-12-15 08:18:59'),
(48, 1, 1, 2, '2021-12-15 10:52:36', '2021-12-15 10:52:36'),
(49, 6, 6, 2, '2021-12-16 09:32:58', '2021-12-16 09:57:26'),
(50, 1, 1, 2, '2021-12-20 09:06:50', '2021-12-20 09:06:50'),
(51, 1, 1, 2, '2021-12-20 09:17:36', '2021-12-20 09:17:36'),
(52, 8, 8, 2, '2021-12-20 09:25:29', '2021-12-20 09:30:33'),
(53, 1, 1, 2, '2021-12-20 09:31:04', '2021-12-20 09:31:04'),
(54, 8, 8, 2, '2021-12-20 09:34:42', '2021-12-20 09:34:42'),
(55, 1, 1, 2, '2021-12-22 13:33:49', '2021-12-22 13:33:49'),
(56, 1, 1, 2, '2021-12-22 13:40:07', '2021-12-22 13:40:07'),
(57, 1, 1, 2, '2021-12-22 13:42:16', '2021-12-22 13:42:16'),
(58, 1, 1, 2, '2021-12-22 13:42:39', '2021-12-22 13:42:39'),
(59, 1, 1, 2, '2021-12-22 13:43:20', '2021-12-22 13:43:20'),
(60, 1, 1, 2, '2021-12-22 13:43:36', '2021-12-22 13:43:36'),
(61, 1, 1, 2, '2021-12-22 13:44:29', '2021-12-22 13:44:29'),
(62, 1, 1, 2, '2021-12-22 13:45:15', '2021-12-22 13:45:15'),
(63, 1, 1, 2, '2021-12-22 13:46:45', '2021-12-22 13:46:45'),
(64, 1, 1, 2, '2021-12-22 13:47:23', '2021-12-22 13:47:23'),
(65, 1, 1, 2, '2021-12-22 13:48:42', '2021-12-22 13:48:42'),
(66, 1, 1, 2, '2021-12-22 13:55:20', '2021-12-22 13:55:20'),
(67, 15, 15, 2, '2021-12-23 09:36:33', '2021-12-23 09:36:33'),
(68, 21, 21, 2, '2022-01-18 10:12:07', '2022-01-18 10:12:07'),
(69, 1, 1, 2, '2022-02-23 13:49:17', '2022-02-23 14:25:00'),
(70, 21, 21, 2, '2022-02-25 12:34:16', '2022-02-25 12:34:16'),
(71, 21, 21, 2, '2022-02-28 08:30:53', '2022-03-17 07:51:35'),
(72, 1, 1, 2, '2022-03-12 14:31:11', '2022-03-12 14:31:11'),
(73, 1, 1, 2, '2022-03-12 14:32:07', '2022-03-12 14:32:07'),
(74, 1, 1, 2, '2022-03-14 09:31:12', '2022-03-14 09:31:12'),
(75, 1, 1, 2, '2022-03-14 09:31:35', '2022-03-14 09:31:35'),
(76, 1, 1, 2, '2022-03-14 09:32:27', '2022-03-14 09:32:27'),
(77, 1, 1, 2, '2022-03-14 09:33:42', '2022-03-14 09:33:42');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE IF NOT EXISTS `countries` (
  `countryid` mediumint unsigned NOT NULL,
  `countryident` varchar(8) DEFAULT NULL,
  `continentid` tinyint(1) NOT NULL DEFAULT '1',
  `zoneid` tinyint unsigned NOT NULL DEFAULT '0',
  `title` varchar(50) NOT NULL DEFAULT '',
  `title_en` varchar(50) NOT NULL DEFAULT '',
  `orderindex` mediumint NOT NULL DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=439 DEFAULT CHARSET=cp1251;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`countryid`, `countryident`, `continentid`, `zoneid`, `title`, `title_en`, `orderindex`) VALUES
(1, 'RU', 1, 2, 'Россия', 'Russia', 1000),
(220, 'UA', 1, 2, 'Украина', 'Ukraine', 999),
(221, 'BY', 1, 2, 'Беларусь', 'Belarus', 998),
(222, 'KZ', 2, 3, 'Казахстан', 'Kazakhstan', 997),
(223, 'DE', 1, 2, 'Германия', 'Germany', 0),
(224, 'ABKHAZIA', 2, 3, 'Абхазия', 'Abkhazia', 0),
(225, 'AU', 6, 7, 'Австралия', 'Australia', 0),
(226, 'AT', 1, 2, 'Австрия', 'Austria', 0),
(227, 'AZ', 2, 3, 'Азербайджан', 'Azerbaijan', 0),
(228, 'AL', 1, 2, 'Албания', 'Albania', 0),
(229, 'DZ', 5, 6, 'Алжир', 'Algeria', 0),
(230, 'AO', 5, 6, 'Ангола', 'Angola', 0),
(231, 'AI', 0, 1, 'Ангуилья', 'Anguilla', 0),
(232, 'AD', 1, 2, 'Андорра', 'Andorra', 0),
(233, 'AG', 3, 4, 'Антигуа и Барбуда', 'Antigua and Barbuda', 0),
(234, 'AN', 0, 1, 'Антильские о-ва', 'Netherlands Antilles', 0),
(235, 'AR', 4, 5, 'Аргентина', 'Argentina', 0),
(236, 'AM', 2, 3, 'Армения', 'Armenia', 0),
(237, 'AW', 0, 1, 'Арулько', 'Aruba', 0),
(238, 'AF', 2, 3, 'Афганистан', 'Afghanistan', 0),
(239, 'BS', 0, 1, 'Багамские о-ва', 'Bahamas', 0),
(240, 'BD', 2, 3, 'Бангладеш', 'Bangladesh', 0),
(241, 'BB', 3, 4, 'Барбадос', 'Barbados', 0),
(242, 'BH', 2, 3, 'Бахрейн', 'Bahrain', 0),
(243, 'BZ', 3, 4, 'Белиз', 'Belize', 0),
(244, 'BE', 1, 2, 'Бельгия', 'Belgium', 0),
(245, 'BJ', 5, 6, 'Бенин', 'Benin', 0),
(246, 'BM', 0, 1, 'Бермуды', 'Bermuda', 0),
(247, 'BG', 1, 2, 'Болгария', 'Bulgaria', 0),
(248, 'BO', 4, 5, 'Боливия', 'Bolivia', 0),
(249, 'BA', 1, 2, 'Босния/Герцеговина', 'Bosnia and Herzegovina', 0),
(250, 'BW', 5, 6, 'Ботсвана', 'Botswana', 0),
(251, 'BR', 4, 5, 'Бразилия', 'Brazil', 0),
(252, 'VG', 0, 1, 'Британские Виргинские о-ва', 'British Virgin Islands', 0),
(253, 'BN', 2, 3, 'Бруней', 'Brunei', 0),
(254, 'BF', 0, 1, 'Буркина Фасо', 'Burkina Faso', 0),
(255, 'BI', 5, 6, 'Бурунди', 'Burundi', 0),
(256, 'BT', 2, 3, 'Бутан', 'Bhutan', 0),
(257, 'WF', 0, 1, 'Валлис и Футуна о-ва', 'Wallis and Futuna', 0),
(258, 'VU', 0, 1, 'Вануату', 'Vanuatu', 0),
(259, 'GB', 1, 2, 'Великобритания', 'United Kingdom', 0),
(260, 'HU', 1, 2, 'Венгрия', 'Hungary', 0),
(261, 'VE', 4, 5, 'Венесуэла', 'Venezuela', 0),
(262, 'TL', 2, 3, 'Восточный Тимор', 'East Timor', 0),
(263, 'VN', 2, 3, 'Вьетнам', 'Vietnam', 0),
(264, 'GA', 5, 6, 'Габон', 'Gabon', 0),
(265, 'HT', 3, 4, 'Гаити', 'Haiti', 0),
(266, 'GY', 4, 5, 'Гайана', 'Guyana', 0),
(267, 'GM', 5, 6, 'Гамбия', 'Gambia', 0),
(268, 'GH', 5, 6, 'Гана', 'Ghana', 0),
(269, 'GP', 0, 1, 'Гваделупа', 'Guadeloupe', 0),
(270, 'GT', 3, 4, 'Гватемала', 'Guatemala', 0),
(271, 'GN', 5, 6, 'Гвинея', 'Guinea', 0),
(272, 'GW', 5, 6, 'Гвинея-Бисау', 'Guinea-Bissau', 0),
(273, 'GG', 0, 1, 'Гернси о-в', 'Guernsey', 0),
(274, 'GI', 1, 2, 'Гибралтар', 'Gibraltar', 0),
(275, 'HN', 3, 4, 'Гондурас', 'Honduras', 0),
(276, 'HK', 2, 3, 'Гонконг', 'Hong Kong', 0),
(277, 'GD', 3, 4, 'Гренада', 'Grenada', 0),
(278, 'GL', 0, 1, 'Гренландия', 'Greenland', 0),
(279, 'GR', 1, 2, 'Греция', 'Greece', 0),
(280, 'GE', 2, 3, 'Грузия', 'Georgia', 0),
(281, 'DK', 1, 2, 'Дания', 'Denmark', 0),
(282, 'JE', 1, 2, 'Джерси о-в', 'Jersey', 0),
(283, 'DJ', 5, 6, 'Джибути', 'Djibouti', 0),
(284, 'DO', 3, 4, 'Доминиканская республика', 'Dominican Republic', 0),
(285, NULL, 1, 2, 'Европы о-в', 'Europa Island', 0),
(286, 'EG', 5, 6, 'Египет', 'Egypt', 0),
(287, 'ZM', 5, 6, 'Замбия', 'Zambia', 0),
(288, 'EH', 0, 1, 'Западная Сахара', 'Western Sahara', 0),
(289, 'ZW', 5, 6, 'Зимбабве', 'Zimbabwe', 0),
(290, 'IL', 2, 3, 'Израиль', 'Israel', 0),
(291, 'IN', 2, 3, 'Индия', 'India', 0),
(292, 'ID', 2, 3, 'Индонезия', 'Indonesia', 0),
(293, 'JO', 2, 3, 'Иордания', 'Jordan', 0),
(294, 'IQ', 2, 3, 'Ирак', 'Iraq', 0),
(295, 'IR', 2, 3, 'Иран', 'Iran', 0),
(296, 'IE', 1, 2, 'Ирландия', 'Ireland', 0),
(297, 'IS', 1, 2, 'Исландия', 'Iceland', 0),
(298, 'ES', 1, 2, 'Испания', 'Spain', 0),
(299, 'IT', 1, 2, 'Италия', 'Italy', 0),
(300, 'YE', 2, 3, 'Йемен', 'Yemen', 0),
(301, 'CV', 5, 6, 'Кабо-Верде', 'Cape Verde', 0),
(302, 'KH', 2, 3, 'Камбоджа', 'Cambodia', 0),
(303, 'CM', 5, 6, 'Камерун', 'Cameroon', 0),
(304, 'CA', 3, 4, 'Канада', 'Canada', 0),
(305, 'QA', 2, 3, 'Катар', 'Qatar', 0),
(306, 'KE', 5, 6, 'Кения', 'Kenya', 0),
(307, 'CY', 2, 3, 'Кипр', 'Cyprus', 0),
(308, 'KI', 0, 1, 'Кирибати', 'Kiribati', 0),
(309, 'CN', 2, 3, 'Китай', 'China', 0),
(310, 'CO', 4, 5, 'Колумбия', 'Colombia', 0),
(311, 'KM', 0, 1, 'Коморские о-ва', 'Comoros', 0),
(312, NULL, 5, 6, 'Конго (Brazzaville)', 'Congo (Brazzaville)', 0),
(313, 'CD', 5, 6, 'Конго (Kinshasa)', 'Congo (Kinshasa)', 0),
(314, 'CR', 3, 4, 'Коста-Рика', 'Costa Rica', 0),
(315, 'CI', 0, 1, 'Кот-д''Ивуар', 'Cote D''Ivoire', 0),
(316, 'CU', 3, 4, 'Куба', 'Cuba', 0),
(317, 'KW', 2, 3, 'Кувейт', 'Kuwait', 0),
(318, 'CK', 0, 1, 'Кука о-ва', 'Cook Islands', 0),
(319, 'KG', 2, 3, 'Кыргызстан', 'Kyrgyzstan', 0),
(320, 'LA', 2, 3, 'Лаос', 'Laos', 0),
(321, 'LV', 1, 2, 'Латвия', 'Latvia', 0),
(322, 'LS', 5, 6, 'Лесото', 'Lesotho', 0),
(323, 'LR', 5, 6, 'Либерия', 'Liberia', 0),
(324, 'LB', 2, 3, 'Ливан', 'Lebanon', 0),
(325, 'LY', 5, 6, 'Ливия', 'Libya', 0),
(326, 'LT', 1, 2, 'Литва', 'Lithuania', 0),
(327, 'LI', 1, 2, 'Лихтенштейн', 'Liechtenstein', 0),
(328, 'LU', 1, 2, 'Люксембург', 'Luxembourg', 0),
(329, 'MU', 5, 6, 'Маврикий', 'Mauritius', 0),
(330, 'MR', 5, 6, 'Мавритания', 'Mauritania', 0),
(331, 'MG', 5, 6, 'Мадагаскар', 'Madagascar', 0),
(332, 'MK', 1, 2, 'Македония', 'Macedonia', 0),
(333, 'MW', 5, 6, 'Малави', 'Malawi', 0),
(334, 'MY', 2, 3, 'Малайзия', 'Malaysia', 0),
(335, 'ML', 5, 6, 'Мали', 'Mali', 0),
(336, 'MV', 0, 1, 'Мальдивские о-ва', 'Maldives', 0),
(337, 'MT', 1, 2, 'Мальта', 'Malta', 0),
(338, 'MQ', 0, 1, 'Мартиника о-в', 'Martinique', 0),
(339, 'MX', 3, 4, 'Мексика', 'Mexico', 0),
(340, 'MZ', 5, 6, 'Мозамбик', 'Mozambique', 0),
(341, 'MD', 1, 2, 'Молдова', 'Moldova', 0),
(342, 'MC', 1, 2, 'Монако', 'Monaco', 0),
(343, 'MN', 2, 3, 'Монголия', 'Mongolia', 0),
(344, 'MA', 5, 6, 'Марокко', 'Morocco', 0),
(345, 'MM', 0, 1, 'Мьянма (Бирма)', 'Myanmar (Burma)', 0),
(346, 'IM', 0, 1, 'Мэн о-в', 'Isle of Man', 0),
(347, 'NA', 5, 6, 'Намибия', 'Namibia', 0),
(348, 'NR', 0, 1, 'Науру', 'Nauru', 0),
(349, 'NP', 2, 3, 'Непал', 'Nepal', 0),
(350, 'NE', 5, 6, 'Нигер', 'Niger', 0),
(351, 'NG', 5, 6, 'Нигерия', 'Nigeria', 0),
(352, 'NL', 1, 2, 'Нидерланды (Голландия)', 'Netherlands', 0),
(353, 'NI', 3, 4, 'Никарагуа', 'Nicaragua', 0),
(354, 'NZ', 0, 1, 'Новая Зеландия', 'New Zealand', 0),
(355, 'NC', 0, 1, 'Новая Каледония о-в', 'New Caledonia', 0),
(356, 'NO', 1, 2, 'Норвегия', 'Norway', 0),
(357, 'NF', 0, 1, 'Норфолк о-в', 'Norfolk Island', 0),
(358, 'AE', 2, 3, 'О.А.Э.', 'United Arab Emirates', 0),
(359, 'OM', 2, 3, 'Оман', 'Oman', 0),
(360, 'PK', 2, 3, 'Пакистан', 'Pakistan', 0),
(361, 'PA', 3, 4, 'Панама', 'Panama', 0),
(362, 'PG', 0, 1, 'Папуа Новая Гвинея', 'Papua New Guinea', 0),
(363, 'PY', 4, 5, 'Парагвай', 'Paraguay', 0),
(364, 'PE', 4, 5, 'Перу', 'Peru', 0),
(365, 'PN', 0, 1, 'Питкэрн о-в', 'Pitcairn Islands', 0),
(366, 'PL', 1, 2, 'Польша', 'Poland', 0),
(367, 'PT', 1, 2, 'Португалия', 'Portugal', 0),
(368, 'PR', 4, 5, 'Пуэрто Рико', 'Puerto Rico', 0),
(369, 'RE', 5, 6, 'Реюньон', 'Reunion', 0),
(370, 'RW', 5, 6, 'Руанда', 'Rwanda', 0),
(371, 'RO', 1, 2, 'Румыния', 'Romania', 0),
(372, 'US', 3, 4, 'США', 'United States', 0),
(373, 'SV', 3, 4, 'Сальвадор', 'El Salvador', 0),
(374, 'WS', 0, 1, 'Самоа', 'Samoa', 0),
(375, 'SM', 1, 2, 'Сан-Марино', 'San Marino', 0),
(376, 'ST', 5, 6, 'Сан-Томе и Принсипи', 'Sao Tome and Principe', 0),
(377, 'SA', 2, 3, 'Саудовская Аравия', 'Saudi Arabia', 0),
(378, 'SZ', 5, 6, 'Свазиленд', 'Swaziland', 0),
(379, 'LC', 0, 1, 'Святая Люсия', 'Saint Lucia', 0),
(380, 'SH', 0, 1, 'Святой Елены о-в', 'Saint Helena', 0),
(381, 'KP', 2, 3, 'Северная Корея', 'North Korea', 0),
(382, 'SC', 0, 1, 'Сейшеллы', 'Seychelles', 0),
(383, 'PM', 0, 1, 'Сен-Пьер и Микелон', 'Saint Pierre and Miquelon', 0),
(384, 'SN', 5, 6, 'Сенегал', 'Senegal', 0),
(385, 'KN', 0, 1, 'Сент Китс и Невис', 'Saint Kitts and Nevis', 0),
(386, 'VC', 3, 4, 'Сент-Винсент и Гренадины', 'Saint Vincent and the Grenadines', 0),
(387, 'RS', 1, 2, 'Сербия', 'Serbia', 0),
(388, 'SG', 2, 3, 'Сингапур', 'Singapore', 0),
(389, 'SY', 2, 3, 'Сирия', 'Syria', 0),
(390, 'SK', 1, 2, 'Словакия', 'Slovakia', 0),
(391, 'SI', 1, 2, 'Словения', 'Slovenia', 0),
(392, 'SB', 0, 1, 'Соломоновы о-ва', 'Solomon Islands', 0),
(393, 'SO', 5, 6, 'Сомали', 'Somalia', 0),
(394, 'SD', 5, 6, 'Судан', 'Sudan', 0),
(395, 'SR', 4, 5, 'Суринам', 'Suriname', 0),
(396, 'SL', 5, 6, 'Сьерра-Леоне', 'Sierra Leone', 0),
(397, 'TJ', 2, 3, 'Таджикистан', 'Tajikistan', 0),
(398, 'TW', 2, 3, 'Тайвань', 'Taiwan', 0),
(399, 'TH', 2, 3, 'Таиланд', 'Thailand', 0),
(400, 'TZ', 5, 6, 'Танзания', 'Tanzania', 0),
(401, 'TG', 5, 6, 'Того', 'Togo', 0),
(402, 'TK', 0, 1, 'Токелау о-ва', 'Tokelau', 0),
(403, 'TO', 0, 1, 'Тонга', 'Tonga', 0),
(404, 'TT', 3, 4, 'Тринидад и Тобаго', 'Trinidad and Tobago', 0),
(405, 'TV', 0, 1, 'Тувалу', 'Tuvalu', 0),
(406, 'TN', 5, 6, 'Тунис', 'Tunisia', 0),
(407, 'TM', 2, 3, 'Туркменистан', 'Turkmenistan', 0),
(408, 'TC', 0, 1, 'Туркс и Кейкос', 'Turks and Caicos Islands', 0),
(409, 'TR', 2, 3, 'Турция', 'Turkey', 0),
(410, 'UG', 5, 6, 'Уганда', 'Uganda', 0),
(411, 'UZ', 2, 3, 'Узбекистан', 'Uzbekistan', 0),
(412, 'UY', 4, 5, 'Уругвай', 'Uruguay', 0),
(413, 'FO', 1, 2, 'Фарерские о-ва', 'Faroe Islands', 0),
(414, 'FJ', 0, 1, 'Фиджи', 'Fiji', 0),
(415, 'PH', 2, 3, 'Филиппины', 'Philippines', 0),
(416, 'FI', 1, 2, 'Финляндия', 'Finland', 0),
(417, 'FR', 1, 2, 'Франция', 'France', 0),
(418, 'GF', 0, 1, 'Французская Гвинея', 'French Guiana', 0),
(419, 'PF', 0, 1, 'Французская Полинезия', 'French Polynesia', 0),
(420, 'HR', 1, 2, 'Хорватия', 'Croatia', 0),
(421, 'TD', 5, 6, 'Чад', 'Chad', 0),
(422, 'ME', 1, 2, 'Черногория', 'Montenegro', 0),
(423, 'CZ', 1, 2, 'Чехия', 'Czech Republic', 0),
(424, 'CL', 4, 5, 'Чили', 'Chile', 0),
(425, 'CH', 1, 2, 'Швейцария', 'Switzerland', 0),
(426, 'SE', 1, 2, 'Швеция', 'Sweden', 0),
(427, 'LK', 2, 3, 'Шри-Ланка', 'Sri Lanka', 0),
(428, 'EC', 4, 5, 'Эквадор', 'Ecuador', 0),
(429, 'GQ', 5, 6, 'Экваториальная Гвинея', 'Equatorial Guinea', 0),
(430, 'ER', 5, 6, 'Эритрея', 'Eritrea', 0),
(431, 'EE', 1, 2, 'Эстония', 'Estonia', 0),
(432, 'ET', 5, 6, 'Эфиопия', 'Ethiopia', 0),
(433, 'ZA', 5, 6, 'ЮАР', 'South Africa', 0),
(434, 'KR', 2, 3, 'Южная Корея', 'South Korea', 0),
(435, 'SOUTH-', 2, 3, 'Южная Осетия', 'South Ossetia', 0),
(436, 'JM', 3, 4, 'Ямайка', 'Jamaica', 0),
(437, 'JP', 2, 3, 'Япония', 'Japan', 0),
(438, 'MO', 2, 3, 'Макао', 'Macau', 0);

-- --------------------------------------------------------

--
-- Table structure for table `custom_files`
--

CREATE TABLE IF NOT EXISTS `custom_files` (
  `id` int unsigned NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `contents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE IF NOT EXISTS `favorites` (
  `user_id` int unsigned NOT NULL,
  `favoriteable_id` int unsigned NOT NULL,
  `favoriteable_type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorites`
--

INSERT INTO `favorites` (`user_id`, `favoriteable_id`, `favoriteable_type`, `created_at`, `updated_at`) VALUES
(1, 1, 'App\\Models\\Listing', '2021-08-30 06:22:21', '2021-08-30 06:22:21'),
(18, 6, 'App\\Models\\Listing', '2021-12-29 08:48:31', '2021-12-29 08:48:31'),
(21, 34, 'App\\Models\\Listing', '2022-02-26 11:32:16', '2022-02-26 11:32:16');

-- --------------------------------------------------------

--
-- Table structure for table `filters`
--

CREATE TABLE IF NOT EXISTS `filters` (
  `id` int unsigned NOT NULL,
  `position` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `search_ui` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_input_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_input_meta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_category_specific` tinyint(1) DEFAULT '0',
  `is_searchable` tinyint(1) DEFAULT '0',
  `is_hidden` tinyint(1) DEFAULT '0',
  `is_default` tinyint(1) DEFAULT '0',
  `categories` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `filters`
--

INSERT INTO `filters` (`id`, `position`, `name`, `field`, `search_ui`, `form_input_type`, `form_input_meta`, `is_category_specific`, `is_searchable`, `is_hidden`, `is_default`, `categories`, `created_at`, `updated_at`) VALUES
(1, 3, 'Price', 'price', 'priceRange', NULL, '{"type":"text","required":false,"label":"Price","className":"form-control","name":"price","subtype":"text"}', 0, 1, 1, 1, '[1,2,3]', '2021-03-12 00:56:53', '2021-12-20 08:34:01'),
(2, 2, 'Categories', 'category_id', 'category', NULL, NULL, NULL, 1, 0, 1, '[]', '2021-03-12 00:56:53', '2021-03-12 00:56:53'),
(3, 1, 'Distance', 'distance', 'distance', NULL, NULL, 0, 1, 1, 1, '[]', '2021-03-12 00:56:53', '2021-06-27 16:59:05'),
(5, 0, 'Deal type', 'type', 'pricingModel', 'none', '{"type":"text","required":false,"label":"Deal type","className":"form-control","name":"type","subtype":"text"}', 0, 1, 0, 0, '[]', '2021-06-27 16:02:40', '2021-06-27 16:59:34'),
(6, 1, 'Shipping', 'shipping', 'refinementList', 'checkbox', '{"type":"checkbox","required":false,"label":"Shipping","toggle":false,"inline":false,"className":"form-control","name":"shipping","other":false,"values":[{"label":"Digital goods","value":"1","selected":true},{"label":"Pick-up","value":"2","selected":true},{"label":"Local shipping","value":"3","selected":true},{"label":"Worldwide shipping","value":"4","selected":true}]}', 0, 1, 0, 0, '[]', '2021-06-27 17:02:34', '2021-09-02 11:23:30');

-- --------------------------------------------------------

--
-- Table structure for table `followables`
--

CREATE TABLE IF NOT EXISTS `followables` (
  `user_id` int unsigned NOT NULL,
  `followable_id` int unsigned NOT NULL,
  `followable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `relation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'follow' COMMENT 'follow/like/subscribe/favorite/upvote/downvote',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `listings`
--

CREATE TABLE IF NOT EXISTS `listings` (
  `id` bigint unsigned NOT NULL,
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `pricing_model_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `blurb` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `stock` int DEFAULT '1',
  `photos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ends_at` datetime DEFAULT NULL,
  `spotlight` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `priority_until` datetime DEFAULT NULL,
  `bold_until` datetime DEFAULT NULL,
  `staff_pick` tinyint(1) DEFAULT NULL,
  `views_count` int DEFAULT NULL,
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `min_units` int DEFAULT '1',
  `max_units` int DEFAULT NULL,
  `min_duration` int DEFAULT NULL,
  `max_duration` int DEFAULT NULL,
  `session_duration` int DEFAULT NULL,
  `pricing_models` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(11,2) DEFAULT NULL,
  `price_ex_vat` decimal(11,2) DEFAULT NULL,
  `btc_price` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_in_btc` tinyint(1) NOT NULL DEFAULT '0',
  `location` point DEFAULT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `variant_options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `vendor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timeslots` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `photos_limit` int DEFAULT NULL,
  `tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tags_string` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `units_in_product_display` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_per_unit_display` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'en',
  `deal_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_private` tinyint(1) DEFAULT '0',
  `is_published` tinyint(1) DEFAULT '0',
  `is_draft` tinyint(1) NOT NULL DEFAULT '0',
  `is_return` tinyint(1) NOT NULL DEFAULT '0',
  `is_admin_verified` datetime DEFAULT NULL,
  `is_disabled` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listings`
--


--
-- Table structure for table `listing_additional_options`
--

CREATE TABLE IF NOT EXISTS `listing_additional_options` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `price` decimal(11,2) DEFAULT NULL,
  `min_quantity` int DEFAULT NULL,
  `max_quantity` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT '0',
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `listing_booked_dates`
--

CREATE TABLE IF NOT EXISTS `listing_booked_dates` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `booked_date` date DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `available_units` int DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT NULL,
  `price` decimal(11,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `listing_booked_times`
--

CREATE TABLE IF NOT EXISTS `listing_booked_times` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `booked_date` datetime DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `duration` int DEFAULT '0',
  `quantity` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `listing_plans`
--

CREATE TABLE IF NOT EXISTS `listing_plans` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(11,2) DEFAULT NULL,
  `credits` int DEFAULT NULL,
  `duration_units` int DEFAULT '1',
  `duration_period` enum('hour','day','week','month','year') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'week',
  `images` int DEFAULT '1',
  `spotlight` tinyint(1) DEFAULT '1',
  `priority` tinyint(1) DEFAULT '1',
  `bold` tinyint(1) DEFAULT '1',
  `category_id` int DEFAULT '1',
  `min_price` int DEFAULT '1',
  `max_price` int DEFAULT '1',
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_plans`
--


--
-- Table structure for table `listing_plan_payments`
--

CREATE TABLE IF NOT EXISTS `listing_plan_payments` (
  `id` int unsigned NOT NULL,
  `user_id` int DEFAULT NULL,
  `listing_id` int DEFAULT NULL,
  `listing_plan_id` int DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `listing_services`
--

CREATE TABLE IF NOT EXISTS `listing_services` (
  `id` int unsigned NOT NULL,
  `listing_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int DEFAULT '0',
  `price` decimal(11,2) DEFAULT '0.00',
  `stock` int DEFAULT '0',
  `position` int DEFAULT '0',
  `meta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_services`
--

-- --------------------------------------------------------

--
-- Table structure for table `listing_shipping_options`
--

CREATE TABLE IF NOT EXISTS `listing_shipping_options` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `price` decimal(11,2) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT '0',
  `parcel_items` int NOT NULL,
  `delivery_days` int NOT NULL,
  `is_default` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `listing_shipping_options`
--


-- --------------------------------------------------------

--
-- Table structure for table `listing_variants`
--

CREATE TABLE IF NOT EXISTS `listing_variants` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `price` decimal(11,2) DEFAULT '0.00',
  `stock` int DEFAULT '0',
  `meta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ltm_translations`
--

CREATE TABLE IF NOT EXISTS `ltm_translations` (
  `id` int unsigned NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `locale` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ltm_translations`
--

INSERT INTO `ltm_translations` (`id`, `status`, `locale`, `group`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 0, 'en', '_json', 'List something', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(2, 0, 'en', '_json', 'Post an announcement', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(3, 0, 'en', '_json', 'unit', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(4, 0, 'en', '_json', 'unit_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(5, 0, 'en', '_json', '_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(6, 0, 'en', '_json', 'Buy', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(7, 0, 'en', '_json', 'Sell something', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(8, 0, 'en', '_json', 'item', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(9, 0, 'en', '_json', 'item_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(10, 0, 'en', '_json', 'Book Room', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(11, 0, 'en', '_json', 'Rent room', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(12, 0, 'en', '_json', 'room', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(13, 0, 'en', '_json', 'room_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(14, 0, 'en', '_json', 'night', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(15, 0, 'en', '_json', 'night_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(16, 0, 'en', '_json', 'Book Session', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(17, 0, 'en', '_json', 'List your service', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(18, 0, 'en', '_json', 'place', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(19, 0, 'en', '_json', 'place_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(20, 0, 'en', '_json', 'session', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(21, 0, 'en', '_json', 'session_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(22, 0, 'en', '_json', 'Rent Item', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(23, 0, 'en', '_json', 'Rent an item', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(24, 0, 'en', '_json', 'day', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(25, 0, 'en', '_json', 'day_plural', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(26, 0, 'en', '_json', 'Request', NULL, '2021-03-12 02:18:01', '2021-03-12 02:18:01'),
(27, 0, 'en', '_json', 'General', NULL, '2021-04-15 06:30:52', '2021-04-15 06:30:52'),
(28, 0, 'en', '_json', 'test', NULL, '2021-04-15 06:54:08', '2021-04-15 06:54:08'),
(29, 0, 'en', '_json', 'Distance', NULL, '2021-05-01 04:02:32', '2021-05-01 04:02:32'),
(30, 0, 'en', '_json', 'Categories', NULL, '2021-05-01 04:02:32', '2021-05-01 04:02:32'),
(31, 0, 'en', '_json', 'Price', NULL, '2021-05-01 04:02:32', '2021-05-01 04:02:32'),
(32, 0, 'en', '_json', 'Test F', NULL, '2021-06-27 15:56:10', '2021-06-27 15:56:10'),
(33, 0, 'en', '_json', 'Size', NULL, '2021-06-27 16:02:40', '2021-06-27 16:02:40'),
(34, 0, 'en', '_json', 'Deal type', NULL, '2021-06-27 16:54:56', '2021-06-27 16:54:56'),
(35, 0, 'en', '_json', 'Shipping', NULL, '2021-06-27 17:02:34', '2021-06-27 17:02:34'),
(36, 0, 'en', '_json', 'Mediation', NULL, '2021-12-10 12:16:56', '2021-12-10 12:16:56'),
(37, 0, 'en', '_json', 'Prepayment', NULL, '2021-12-10 12:17:46', '2021-12-10 12:17:46'),
(38, 0, 'en', '_json', 'Postpayment', NULL, '2021-12-10 12:18:33', '2021-12-10 12:18:33'),
(39, 0, 'en', '_json', 'test2', NULL, '2021-12-20 07:37:35', '2021-12-20 07:37:35');

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE IF NOT EXISTS `menus` (
  `id` int unsigned NOT NULL,
  `locale` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `locale`, `location`, `items`, `created_at`, `updated_at`) VALUES
(3, 'en', 'top', '[]', '2021-03-12 00:56:53', '2021-04-17 13:46:26'),
(4, 'ru', 'top', '[{"title":"About","url":"\\/about","position":1},{"title":"browse","url":"\\/browse","position":2}]', '2021-03-12 14:45:39', '2021-04-15 06:29:56'),
(5, 'US', 'top', '[{"title":"About Us","url":"\\/about","position":1},{"title":"Browse","url":"\\/browse","position":2}]', '2021-04-17 13:47:35', '2021-04-17 13:47:35');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int unsigned NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_seen` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_from_sender` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_from_receiver` tinyint(1) NOT NULL DEFAULT '0',
  `user_id` int NOT NULL,
  `conversation_id` int NOT NULL,
  `attachments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `message`, `is_seen`, `deleted_from_sender`, `deleted_from_receiver`, `user_id`, `conversation_id`, `attachments`, `created_at`, `updated_at`) VALUES
(1, 'test', 0, 0, 0, 1, 1, NULL, '1984-09-05 11:47:41', '1984-09-05 11:47:41'),
(2, '2332323232323', 0, 0, 0, 1, 1, NULL, '2021-06-14 10:56:43', '2021-06-14 10:56:43'),
(3, 'testb 123', 1, 0, 0, 1, 2, NULL, '2021-06-14 11:07:51', '2021-06-14 11:16:46'),
(4, 'test', 1, 0, 0, 2, 2, NULL, '2021-06-14 11:08:08', '2021-06-14 11:10:20'),
(5, '21313123123', 1, 0, 0, 1, 2, NULL, '2021-06-14 11:08:58', '2021-06-14 11:16:46'),
(6, '21313123123', 1, 0, 0, 1, 2, NULL, '2021-06-14 11:10:20', '2021-06-14 11:16:46'),
(7, '121212121', 1, 0, 0, 1, 2, NULL, '2021-06-14 11:23:24', '2021-06-14 11:27:51'),
(8, '12121', 1, 0, 0, 1, 2, NULL, '2021-06-14 11:28:16', '2021-06-14 11:28:26'),
(9, '121212', 1, 0, 0, 2, 2, NULL, '2021-06-14 11:28:34', '2021-06-14 11:29:35'),
(10, '4444444444444444', 1, 0, 0, 2, 2, NULL, '2021-06-14 11:28:44', '2021-06-14 11:29:35'),
(11, '22222222222', 1, 0, 0, 2, 2, NULL, '2021-06-14 11:30:00', '2021-06-14 11:30:50'),
(12, 'test 123', 0, 0, 0, 1, 3, NULL, '2021-06-28 02:42:38', '2021-06-28 02:42:38'),
(13, 'test 321', 1, 0, 0, 1, 4, NULL, '2021-06-28 02:50:38', '2021-08-22 13:23:59'),
(14, 'test 333222', 0, 0, 0, 1, 5, NULL, '2021-06-28 02:58:31', '2021-06-28 02:58:31'),
(15, '232323232322', 0, 0, 0, 1, 6, NULL, '2021-06-28 02:59:08', '2021-06-28 02:59:08'),
(16, 'sfsafsaf', 1, 0, 0, 1, 7, NULL, '2021-06-28 03:01:00', '2021-11-23 14:16:41'),
(17, 'safsafafaf', 1, 0, 0, 1, 4, NULL, '2021-06-28 03:06:05', '2021-08-22 13:23:59'),
(18, 'test 1', 1, 0, 0, 1, 8, NULL, '2021-06-28 03:15:37', '2021-08-22 13:47:06'),
(19, 'test 2', 1, 0, 0, 1, 8, NULL, '2021-06-28 03:15:47', '2021-08-22 13:47:06'),
(20, 'test 33', 1, 0, 0, 1, 8, NULL, '2021-06-28 03:15:54', '2021-08-22 13:47:06'),
(21, 'test mediator', 1, 0, 0, 3, 8, NULL, '2021-08-22 13:47:41', '2021-08-22 13:47:53'),
(22, 'test', 0, 0, 0, 1, 9, NULL, '2021-08-22 13:48:18', '2021-08-22 13:48:18'),
(23, 'test', 0, 0, 0, 1, 9, NULL, '2021-08-22 13:50:03', '2021-08-22 13:50:03'),
(24, 'test', 0, 0, 0, 1, 9, NULL, '2021-08-22 13:53:46', '2021-08-22 13:53:46'),
(25, 'test 12345', 0, 0, 0, 1, 9, NULL, '2021-08-22 13:54:36', '2021-08-22 13:54:36'),
(26, 'mediator test', 1, 0, 0, 1, 8, NULL, '2021-08-22 13:58:03', '2021-08-22 13:59:09'),
(27, 'mediator test 2', 1, 0, 0, 1, 8, NULL, '2021-08-22 13:59:03', '2021-08-22 13:59:09'),
(28, 'test', 0, 0, 0, 1, 10, NULL, '2021-09-06 10:04:03', '2021-09-06 10:04:03'),
(29, 'test4', 0, 0, 0, 1, 11, NULL, '2021-09-06 10:05:35', '2021-09-06 10:05:35'),
(30, 'Hi, UID set to nobody', 0, 0, 0, 1, 8, NULL, '2021-09-15 07:51:52', '2021-09-15 07:51:52'),
(31, 'Hi, UID set to nobody', 0, 0, 0, 1, 11, NULL, '2021-09-15 07:53:57', '2021-09-15 07:53:57'),
(32, 'Hi, UID set to nobody', 0, 0, 0, 1, 11, NULL, '2021-09-15 07:54:25', '2021-09-15 07:54:25'),
(33, 'test3', 0, 0, 0, 1, 12, NULL, '2021-10-19 12:53:32', '2021-10-19 12:53:32'),
(34, 'test2', 0, 0, 0, 1, 13, NULL, '2021-10-20 08:25:41', '2021-10-20 08:25:41'),
(35, 'test', 0, 0, 0, 1, 14, NULL, '2021-10-20 12:18:02', '2021-10-20 12:18:02'),
(36, 'test', 0, 0, 0, 1, 15, NULL, '2021-10-22 08:54:30', '2021-10-22 08:54:30'),
(37, 'test', 0, 0, 0, 1, 16, NULL, '2021-10-22 08:54:57', '2021-10-22 08:54:57'),
(38, 'test', 0, 0, 0, 1, 17, NULL, '2021-10-22 08:56:20', '2021-10-22 08:56:20'),
(39, 'test', 0, 0, 0, 1, 18, NULL, '2021-10-22 11:13:16', '2021-10-22 11:13:16'),
(40, 'test', 0, 0, 0, 1, 19, NULL, '2021-10-22 13:15:34', '2021-10-22 13:15:34'),
(41, 'test', 0, 0, 0, 1, 20, NULL, '2021-11-04 14:30:11', '2021-11-04 14:30:11'),
(42, 'test', 0, 0, 0, 1, 21, NULL, '2021-11-10 09:53:39', '2021-11-10 09:53:39'),
(43, 'test', 0, 0, 0, 1, 22, NULL, '2021-11-20 14:31:21', '2021-11-20 14:31:21'),
(44, 'test', 0, 0, 0, 1, 23, NULL, '2021-11-20 14:33:52', '2021-11-20 14:33:52'),
(45, 'test', 0, 0, 0, 1, 24, NULL, '2021-11-20 14:35:41', '2021-11-20 14:35:41'),
(46, 'test', 0, 0, 0, 1, 25, NULL, '2021-11-20 14:37:36', '2021-11-20 14:37:36'),
(47, 'test', 0, 0, 0, 1, 26, NULL, '2021-11-20 14:41:06', '2021-11-20 14:41:06'),
(48, 'test', 0, 0, 0, 1, 27, NULL, '2021-11-22 13:31:16', '2021-11-22 13:31:16'),
(49, 'test jdsajd san dkljas ds naslkjd', 1, 0, 0, 1, 4, NULL, '2021-11-23 14:02:49', '2021-12-13 13:55:50'),
(50, 'test 1234', 1, 0, 0, 1, 7, NULL, '2021-11-23 14:15:45', '2021-11-23 14:16:41'),
(51, 'cfxxcxc', 1, 0, 0, 1, 7, NULL, '2021-11-23 14:19:39', '2021-11-23 14:32:13'),
(52, 'cfxxcxc', 1, 0, 0, 1, 7, NULL, '2021-11-23 14:27:03', '2021-11-23 14:32:13'),
(53, 'tesssttttt 55555', 1, 0, 0, 1, 7, NULL, '2021-11-23 14:31:45', '2021-11-23 14:32:13'),
(54, 'test', 0, 0, 0, 1, 28, NULL, '2021-11-24 14:39:58', '2021-11-24 14:39:58'),
(55, 'test', 0, 0, 0, 1, 29, NULL, '2021-11-26 07:44:15', '2021-11-26 07:44:15'),
(56, 'test', 0, 0, 0, 1, 30, NULL, '2021-11-30 15:38:27', '2021-11-30 15:38:27'),
(57, 'test', 0, 0, 0, 1, 31, NULL, '2021-11-30 15:40:26', '2021-11-30 15:40:26'),
(58, 'test', 0, 0, 0, 1, 32, NULL, '2021-12-09 15:00:53', '2021-12-09 15:00:53'),
(59, 'test', 0, 0, 0, 1, 33, NULL, '2021-12-09 15:01:50', '2021-12-09 15:01:50'),
(60, 'test', 0, 0, 0, 1, 34, NULL, '2021-12-09 15:07:41', '2021-12-09 15:07:41'),
(61, 'test', 0, 0, 0, 1, 35, NULL, '2021-12-09 15:13:48', '2021-12-09 15:13:48'),
(62, 'test', 0, 0, 0, 1, 36, NULL, '2021-12-09 15:14:25', '2021-12-09 15:14:25'),
(63, 'test', 0, 0, 0, 1, 37, NULL, '2021-12-09 15:15:08', '2021-12-09 15:15:08'),
(64, 'test', 0, 0, 0, 1, 38, NULL, '2021-12-09 15:17:48', '2021-12-09 15:17:48'),
(65, 'test', 0, 0, 0, 1, 39, NULL, '2021-12-09 15:18:37', '2021-12-09 15:18:37'),
(66, 'test', 0, 0, 0, 1, 40, NULL, '2021-12-09 15:19:27', '2021-12-09 15:19:27'),
(67, 'test', 0, 0, 0, 1, 41, NULL, '2021-12-09 15:19:43', '2021-12-09 15:19:43'),
(68, 'test', 0, 0, 0, 1, 42, NULL, '2021-12-09 15:20:18', '2021-12-09 15:20:18'),
(69, 'test', 0, 0, 0, 1, 43, NULL, '2021-12-09 15:22:16', '2021-12-09 15:22:16'),
(70, 'test', 0, 0, 0, 1, 44, NULL, '2021-12-09 15:23:20', '2021-12-09 15:23:20'),
(71, 'test', 0, 0, 0, 1, 45, NULL, '2021-12-09 15:24:52', '2021-12-09 15:24:52'),
(72, 'test', 1, 0, 0, 1, 46, NULL, '2021-12-09 15:25:45', '2021-12-13 13:56:16'),
(73, 'test', 1, 0, 0, 3, 46, NULL, '2021-12-13 13:56:40', '2021-12-13 14:31:50'),
(74, 'test', 1, 0, 0, 5, 47, NULL, '2021-12-15 08:18:59', '2021-12-15 15:43:13'),
(75, 'test', 0, 0, 0, 1, 48, NULL, '2021-12-15 10:52:36', '2021-12-15 10:52:36'),
(76, 'test', 1, 0, 0, 6, 49, NULL, '2021-12-16 09:32:58', '2021-12-20 07:57:08'),
(77, 'Ok', 1, 0, 0, 6, 49, NULL, '2021-12-16 09:55:10', '2021-12-20 07:57:08'),
(78, 'hello, test2', 1, 0, 0, 6, 49, NULL, '2021-12-16 09:57:00', '2021-12-20 07:57:08'),
(79, 'hello, test2', 1, 0, 0, 6, 49, NULL, '2021-12-16 09:57:26', '2021-12-20 07:57:08'),
(80, 'test', 0, 0, 0, 1, 50, NULL, '2021-12-20 09:06:50', '2021-12-20 09:06:50'),
(81, 'test', 0, 0, 0, 1, 51, NULL, '2021-12-20 09:17:36', '2021-12-20 09:17:36'),
(82, 'test', 1, 0, 0, 8, 52, NULL, '2021-12-20 09:25:29', '2021-12-20 09:27:10'),
(83, 'a', 0, 0, 0, 1, 52, NULL, '2021-12-20 09:30:17', '2021-12-20 09:30:17'),
(84, 'adsfsdfsdf', 0, 0, 0, 1, 52, NULL, '2021-12-20 09:30:33', '2021-12-20 09:30:33'),
(85, 'test', 0, 0, 0, 1, 53, NULL, '2021-12-20 09:31:04', '2021-12-20 09:31:04'),
(86, 'test', 1, 0, 0, 8, 54, NULL, '2021-12-20 09:34:42', '2021-12-20 09:35:47'),
(87, 'test', 0, 0, 0, 1, 55, NULL, '2021-12-22 13:33:49', '2021-12-22 13:33:49'),
(88, 'test', 0, 0, 0, 1, 56, NULL, '2021-12-22 13:40:07', '2021-12-22 13:40:07'),
(89, 'test', 0, 0, 0, 1, 57, NULL, '2021-12-22 13:42:16', '2021-12-22 13:42:16'),
(90, 'test', 0, 0, 0, 1, 58, NULL, '2021-12-22 13:42:39', '2021-12-22 13:42:39'),
(91, 'test', 0, 0, 0, 1, 59, NULL, '2021-12-22 13:43:20', '2021-12-22 13:43:20'),
(92, 'test', 0, 0, 0, 1, 60, NULL, '2021-12-22 13:43:36', '2021-12-22 13:43:36'),
(93, 'test', 0, 0, 0, 1, 61, NULL, '2021-12-22 13:44:29', '2021-12-22 13:44:29'),
(94, 'test', 0, 0, 0, 1, 62, NULL, '2021-12-22 13:45:15', '2021-12-22 13:45:15'),
(95, 'test', 0, 0, 0, 1, 63, NULL, '2021-12-22 13:46:45', '2021-12-22 13:46:45'),
(96, 'test', 0, 0, 0, 1, 64, NULL, '2021-12-22 13:47:23', '2021-12-22 13:47:23'),
(97, 'test', 0, 0, 0, 1, 65, NULL, '2021-12-22 13:48:42', '2021-12-22 13:48:42'),
(98, 'test', 0, 0, 0, 1, 66, NULL, '2021-12-22 13:55:20', '2021-12-22 13:55:20'),
(99, 'test', 1, 0, 0, 15, 67, NULL, '2021-12-23 09:36:33', '2021-12-27 10:51:59'),
(100, 'This is "Automatic comment for paid deal"', 0, 0, 0, 21, 68, NULL, '2022-01-18 10:12:07', '2022-01-18 10:12:07'),
(101, '1', 0, 0, 0, 1, 69, NULL, '2022-02-23 13:49:17', '2022-02-23 13:49:17'),
(102, 'Shipping info tex\r\n1\r\n1\r\n2\r\n\r\n2\r\n\r\n4\r\n5\r\n5\r\n5\r\n5', 0, 0, 0, 1, 69, NULL, '2022-02-23 14:25:00', '2022-02-23 14:25:00'),
(103, 'comment #1\r\n', 0, 0, 0, 21, 70, NULL, '2022-02-25 12:34:16', '2022-02-25 12:34:16'),
(104, 'comment #2\r\n', 0, 0, 0, 21, 71, NULL, '2022-02-28 08:30:53', '2022-02-28 08:30:53'),
(105, '1', 0, 0, 0, 1, 72, NULL, '2022-03-12 14:31:11', '2022-03-12 14:31:11'),
(106, '1', 0, 0, 0, 1, 73, NULL, '2022-03-12 14:32:07', '2022-03-12 14:32:07'),
(107, 'This is "Automatic comment for paid deal".', 0, 0, 0, 1, 74, NULL, '2022-03-14 09:31:12', '2022-03-14 09:31:12'),
(108, 'This is "Automatic comment for paid deal".', 0, 0, 0, 1, 75, NULL, '2022-03-14 09:31:35', '2022-03-14 09:31:35'),
(109, 'This is "Automatic comment for paid deal".', 0, 0, 0, 1, 76, NULL, '2022-03-14 09:32:27', '2022-03-14 09:32:27'),
(110, 'This is "Automatic comment for paid deal".', 0, 0, 0, 1, 77, NULL, '2022-03-14 09:33:42', '2022-03-14 09:33:42'),
(111, 'okey', 0, 0, 0, 21, 71, NULL, '2022-03-17 07:51:35', '2022-03-17 07:51:35');

-- --------------------------------------------------------

--
-- Table structure for table `meta`
--

CREATE TABLE IF NOT EXISTS `meta` (
  `id` int unsigned NOT NULL,
  `metable_id` int unsigned NOT NULL,
  `metable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meta`
--

INSERT INTO `meta` (`id`, `metable_id`, `metable_type`, `key`, `value`) VALUES
(1, 5, 'App\\Models\\Role', 'selectable', '0');

-- --------------------------------------------------------

--
-- Table structure for table `metatags`
--

CREATE TABLE IF NOT EXISTS `metatags` (
  `id` int unsigned NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `metatagable_id` int DEFAULT NULL,
  `metatagable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `other` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `h1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `canonical` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `robots` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `changefreq` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meta_attributes`
--

CREATE TABLE IF NOT EXISTS `meta_attributes` (
  `meta_id` int unsigned NOT NULL,
  `meta_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string',
  `meta_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `metable_id` bigint unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=465 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meta_attributes`
--

INSERT INTO `meta_attributes` (`meta_id`, `meta_key`, `meta_value`, `meta_type`, `meta_group`, `metable_type`, `metable_id`) VALUES
(1, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 1),
(2, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 1),
(3, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 1),
(4, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 2),
(5, 'shipping_address', '{"zip":"123","city":"123","state":"123","address":"Test","country":null,"full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 2),
(6, 'billing_address', '{"zip":"123","city":"123","state":"123","address":"Test","country":null,"full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 2),
(7, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 3),
(8, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 3),
(9, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 3),
(10, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 4),
(11, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 4),
(12, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 4),
(13, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 5),
(14, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 5),
(15, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 5),
(16, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 6),
(17, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 6),
(18, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 6),
(19, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 7),
(20, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 7),
(21, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 7),
(22, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 8),
(23, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 8),
(24, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 8),
(25, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 9),
(26, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 9),
(27, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 9),
(28, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 10),
(29, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 10),
(30, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 10),
(31, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 11),
(32, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 11),
(33, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 11),
(34, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 12),
(35, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 12),
(36, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 12),
(37, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 13),
(38, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 13),
(39, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 13),
(40, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 14),
(41, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 14),
(42, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 14),
(43, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 15),
(44, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 15),
(45, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 15),
(46, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 16),
(47, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 16),
(48, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 16),
(49, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 17),
(50, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 17),
(51, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 17),
(52, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 18),
(53, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 18),
(54, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 18),
(55, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 19),
(56, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 19),
(57, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 19),
(58, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 20),
(59, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 20),
(60, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 20),
(61, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 21),
(62, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 21),
(63, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 21),
(64, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 22),
(65, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 22),
(66, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 22),
(67, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 23),
(68, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 23),
(69, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 23),
(70, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 24),
(71, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 24),
(72, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 24),
(73, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 25),
(74, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 25),
(75, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 25),
(76, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 26),
(77, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 26),
(78, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 26),
(79, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 27),
(80, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 27),
(81, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 27),
(82, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 28),
(83, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 28),
(84, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 28),
(85, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 29),
(86, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 29),
(87, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 29),
(88, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 30),
(89, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 30),
(90, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 30),
(91, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 31),
(92, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 31),
(93, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 31),
(94, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 32),
(95, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 32),
(96, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 32),
(97, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 33),
(98, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 33),
(99, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 33),
(100, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 34),
(101, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 34),
(102, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 34),
(103, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 35),
(104, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 35),
(105, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 35),
(106, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 36),
(107, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 36),
(108, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 36),
(109, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 37),
(110, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 37),
(111, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 37),
(112, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 38),
(113, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 38),
(114, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 38),
(115, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 39),
(116, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 39),
(117, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 39),
(118, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 40),
(119, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 40),
(120, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 40),
(121, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 40),
(122, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 40),
(123, 'timestamp', '1639069253', 'integer', NULL, 'App\\Models\\Order', 40),
(124, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 41),
(125, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 41),
(126, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 41),
(127, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 41),
(128, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 41),
(129, 'timestamp', '1639069310', 'integer', NULL, 'App\\Models\\Order', 41),
(130, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 42),
(131, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 42),
(132, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 42),
(133, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 42),
(134, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 42),
(135, 'timestamp', '1639069661', 'integer', NULL, 'App\\Models\\Order', 42),
(136, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 43),
(137, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 43),
(138, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 43),
(139, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 43),
(140, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 43),
(141, 'timestamp', '1639070028', 'integer', NULL, 'App\\Models\\Order', 43),
(142, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 44),
(143, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 44),
(144, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 44),
(145, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 44),
(146, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 44),
(147, 'timestamp', '1639070065', 'integer', NULL, 'App\\Models\\Order', 44),
(148, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 45),
(149, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 45),
(150, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 45),
(151, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 45),
(152, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 45),
(153, 'timestamp', '1639070108', 'integer', NULL, 'App\\Models\\Order', 45),
(154, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 46),
(155, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 46),
(156, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 46),
(157, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 46),
(158, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 46),
(159, 'timestamp', '1639070268', 'integer', NULL, 'App\\Models\\Order', 46),
(160, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 47),
(161, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 47),
(162, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 47),
(163, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 47),
(164, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 47),
(165, 'timestamp', '1639070317', 'integer', NULL, 'App\\Models\\Order', 47),
(166, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 48),
(167, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 48),
(168, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 48),
(169, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 48),
(170, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 48),
(171, 'timestamp', '1639070367', 'integer', NULL, 'App\\Models\\Order', 48),
(172, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 49),
(173, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 49),
(174, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 49),
(175, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 49),
(176, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 49),
(177, 'timestamp', '1639070383', 'integer', NULL, 'App\\Models\\Order', 49),
(178, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 50),
(179, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 50),
(180, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 50),
(181, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 50),
(182, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 50),
(183, 'timestamp', '1639070418', 'integer', NULL, 'App\\Models\\Order', 50),
(184, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 51),
(185, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 51),
(186, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 51),
(187, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 51),
(188, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 51),
(189, 'timestamp', '1639070536', 'integer', NULL, 'App\\Models\\Order', 51),
(190, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 52),
(191, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 52),
(192, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 52),
(193, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 52),
(194, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 52),
(195, 'timestamp', '1639070600', 'integer', NULL, 'App\\Models\\Order', 52),
(196, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 53),
(197, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 53),
(198, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 53),
(199, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 53),
(200, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 53),
(201, 'timestamp', '1639070692', 'integer', NULL, 'App\\Models\\Order', 53),
(202, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 54),
(203, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 54),
(204, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 54),
(205, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 54),
(206, 'btc_payment_sum', '0.00111015', 'float', NULL, 'App\\Models\\Order', 54),
(207, 'timestamp', '1639070745', 'integer', NULL, 'App\\Models\\Order', 54),
(208, 'dispute_user_timestamp', '1639408852', 'integer', NULL, 'App\\Models\\Order', 54),
(209, 'dispute_user_info', '{"reason":"3","problem":"damaged","proposal":"1","notes":null,"img_location":""}', 'array', NULL, 'App\\Models\\Order', 54),
(210, 'dispute_seller_timestamp', '1639408852', 'integer', NULL, 'App\\Models\\Order', 54),
(211, 'dispute_seller_info', '{"proposal":"1","notes":null,"img_location":""}', 'array', NULL, 'App\\Models\\Order', 54),
(212, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 55),
(213, 'shipping_address', '{"zip":"1020000","city":null,"state":null,"address":null,"country":"US","full_name":"Tester"}', 'array', NULL, 'App\\Models\\Order', 55),
(214, 'billing_address', '{"zip":"1020000","city":null,"state":null,"address":null,"country":"US","full_name":"Tester"}', 'array', NULL, 'App\\Models\\Order', 55),
(215, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 55),
(216, 'btc_payment_sum', '0.00112262', 'float', NULL, 'App\\Models\\Order', 55),
(217, 'timestamp', '1639563539', 'integer', NULL, 'App\\Models\\Order', 55),
(218, 'end_timestamp', '1641723539', 'integer', NULL, 'App\\Models\\Order', 55),
(219, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 56),
(220, 'shipping_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 56),
(221, 'billing_address', '{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}', 'array', NULL, 'App\\Models\\Order', 56),
(222, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 56),
(223, 'btc_payment_sum', '0.00112632', 'float', NULL, 'App\\Models\\Order', 56),
(224, 'timestamp', '1639572756', 'integer', NULL, 'App\\Models\\Order', 56),
(225, 'end_timestamp', '1639659156', 'integer', NULL, 'App\\Models\\Order', 56),
(226, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 57),
(227, 'shipping_address', '{"zip":"1020000","city":"City","state":null,"address":"Home Street, My House","country":"US","full_name":"James"}', 'array', NULL, 'App\\Models\\Order', 57),
(228, 'billing_address', '{"zip":"1020000","city":"City","state":null,"address":"Home Street, My House","country":"US","full_name":"James"}', 'array', NULL, 'App\\Models\\Order', 57),
(229, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 57),
(230, 'btc_payment_sum', '0.00110794', 'float', NULL, 'App\\Models\\Order', 57),
(231, 'timestamp', '1639654378', 'integer', NULL, 'App\\Models\\Order', 57),
(232, 'end_timestamp', '1641814378', 'integer', NULL, 'App\\Models\\Order', 57),
(233, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 58),
(234, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 58),
(235, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 58),
(236, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 58),
(237, 'btc_payment_sum', '0.0011778', 'float', NULL, 'App\\Models\\Order', 58),
(238, 'timestamp', '1639998410', 'integer', NULL, 'App\\Models\\Order', 58),
(239, 'end_timestamp', '1640862410', 'integer', NULL, 'App\\Models\\Order', 58),
(240, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 59),
(241, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 59),
(242, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 59),
(243, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 59),
(244, 'btc_payment_sum', '0.0011778', 'float', NULL, 'App\\Models\\Order', 59),
(245, 'timestamp', '1639999056', 'integer', NULL, 'App\\Models\\Order', 59),
(246, 'end_timestamp', '1642159056', 'integer', NULL, 'App\\Models\\Order', 59),
(247, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 60),
(248, 'shipping_address', '{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"}', 'array', NULL, 'App\\Models\\Order', 60),
(249, 'billing_address', '{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"}', 'array', NULL, 'App\\Models\\Order', 60),
(250, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 60),
(251, 'btc_payment_sum', '0.0011778', 'float', NULL, 'App\\Models\\Order', 60),
(252, 'timestamp', '1639999529', 'integer', NULL, 'App\\Models\\Order', 60),
(253, 'end_timestamp', '1640085929', 'integer', NULL, 'App\\Models\\Order', 60),
(254, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 61),
(255, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 61),
(256, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 61),
(257, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 61),
(258, 'btc_payment_sum', '0.0011778', 'float', NULL, 'App\\Models\\Order', 61),
(259, 'timestamp', '1639999864', 'integer', NULL, 'App\\Models\\Order', 61),
(260, 'end_timestamp', '1642159864', 'integer', NULL, 'App\\Models\\Order', 61),
(261, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 62),
(262, 'shipping_address', '{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"}', 'array', NULL, 'App\\Models\\Order', 62),
(263, 'billing_address', '{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"}', 'array', NULL, 'App\\Models\\Order', 62),
(264, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 62),
(265, 'btc_payment_sum', '0.00117364', 'float', NULL, 'App\\Models\\Order', 62),
(266, 'timestamp', '1640000082', 'integer', NULL, 'App\\Models\\Order', 62),
(267, 'end_timestamp', '1640086482', 'integer', NULL, 'App\\Models\\Order', 62),
(268, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 63),
(269, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 63),
(270, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 63),
(271, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 63),
(272, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 63),
(273, 'timestamp', '1640187229', 'integer', NULL, 'App\\Models\\Order', 63),
(274, 'end_timestamp', '1640612029', 'integer', NULL, 'App\\Models\\Order', 63),
(275, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 64),
(276, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 64),
(277, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 64),
(278, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 64),
(279, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 64),
(280, 'timestamp', '1640187607', 'integer', NULL, 'App\\Models\\Order', 64),
(281, 'end_timestamp', '1640274007', 'integer', NULL, 'App\\Models\\Order', 64),
(282, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 65),
(283, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 65),
(284, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 65),
(285, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 65),
(286, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 65),
(287, 'timestamp', '1640187736', 'integer', NULL, 'App\\Models\\Order', 65),
(288, 'end_timestamp', '1640274136', 'integer', NULL, 'App\\Models\\Order', 65),
(289, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 66),
(290, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 66),
(291, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 66),
(292, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 66),
(293, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 66),
(294, 'timestamp', '1640187759', 'integer', NULL, 'App\\Models\\Order', 66),
(295, 'end_timestamp', '1640274159', 'integer', NULL, 'App\\Models\\Order', 66),
(296, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 67),
(297, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 67),
(298, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 67),
(299, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 67),
(300, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 67),
(301, 'timestamp', '1640187800', 'integer', NULL, 'App\\Models\\Order', 67),
(302, 'end_timestamp', '1640274200', 'integer', NULL, 'App\\Models\\Order', 67),
(303, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 68),
(304, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 68),
(305, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 68),
(306, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 68),
(307, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 68),
(308, 'timestamp', '1640187816', 'integer', NULL, 'App\\Models\\Order', 68),
(309, 'end_timestamp', '1640274216', 'integer', NULL, 'App\\Models\\Order', 68),
(310, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 69),
(311, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 69),
(312, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 69),
(313, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 69),
(314, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 69),
(315, 'timestamp', '1640187869', 'integer', NULL, 'App\\Models\\Order', 69),
(316, 'end_timestamp', '1640274269', 'integer', NULL, 'App\\Models\\Order', 69),
(317, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 70),
(318, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 70),
(319, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 70),
(320, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 70),
(321, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 70),
(322, 'timestamp', '1640187915', 'integer', NULL, 'App\\Models\\Order', 70),
(323, 'end_timestamp', '1640274315', 'integer', NULL, 'App\\Models\\Order', 70),
(324, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 71),
(325, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 71),
(326, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 71),
(327, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 71),
(328, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 71),
(329, 'timestamp', '1640188005', 'integer', NULL, 'App\\Models\\Order', 71),
(330, 'end_timestamp', '1640274405', 'integer', NULL, 'App\\Models\\Order', 71),
(331, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 72),
(332, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 72),
(333, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 72),
(334, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 72),
(335, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 72),
(336, 'timestamp', '1640188043', 'integer', NULL, 'App\\Models\\Order', 72),
(337, 'end_timestamp', '1640274443', 'integer', NULL, 'App\\Models\\Order', 72),
(338, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 73),
(339, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 73),
(340, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 73),
(341, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 73),
(342, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 73),
(343, 'timestamp', '1640188122', 'integer', NULL, 'App\\Models\\Order', 73),
(344, 'end_timestamp', '1640274522', 'integer', NULL, 'App\\Models\\Order', 73),
(345, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 74),
(346, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 74),
(347, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 74),
(348, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 74),
(349, 'btc_payment_sum', '0.00111061', 'float', NULL, 'App\\Models\\Order', 74),
(350, 'timestamp', '1640188520', 'integer', NULL, 'App\\Models\\Order', 74),
(351, 'end_timestamp', '1640274920', 'integer', NULL, 'App\\Models\\Order', 74),
(352, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 75),
(353, 'shipping_address', '{"zip":"1020000","city":"u5-City","state":"u5-State","address":"u5-Home","country":"BS","full_name":"u5"}', 'array', NULL, 'App\\Models\\Order', 75),
(354, 'billing_address', '{"zip":"1020000","city":"u5-City","state":"u5-State","address":"u5-Home","country":"BS","full_name":"u5"}', 'array', NULL, 'App\\Models\\Order', 75),
(355, 'bd_type', 'postpayment', 'string', NULL, 'App\\Models\\Order', 75),
(356, 'btc_payment_sum', '0.00113566', 'float', NULL, 'App\\Models\\Order', 75),
(357, 'timestamp', '1640259393', 'integer', NULL, 'App\\Models\\Order', 75),
(358, 'end_timestamp', '1640345793', 'integer', NULL, 'App\\Models\\Order', 75),
(359, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 76),
(360, 'shipping_address', '{"zip":"1020000","city":"MyCity","state":"MyState","address":"MyAddress","country":"US","full_name":"u08"}', 'array', NULL, 'App\\Models\\Order', 76),
(361, 'billing_address', '{"zip":"1020000","city":"MyCity","state":"MyState","address":"MyAddress","country":"US","full_name":"u08"}', 'array', NULL, 'App\\Models\\Order', 76),
(362, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 76),
(363, 'btc_payment_sum', '0.0000701', 'float', NULL, 'App\\Models\\Order', 76),
(364, 'timestamp', '1640775890', 'integer', NULL, 'App\\Models\\Order', 76),
(365, 'end_timestamp', '1640862290', 'integer', NULL, 'App\\Models\\Order', 76),
(366, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 77),
(367, 'shipping_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 77),
(368, 'billing_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 77),
(369, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 77),
(370, 'btc_payment_sum', '0.00002384', 'float', NULL, 'App\\Models\\Order', 77),
(371, 'timestamp', '1642507927', 'integer', NULL, 'App\\Models\\Order', 77),
(372, 'end_timestamp', '1642594327', 'integer', NULL, 'App\\Models\\Order', 77),
(373, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 78),
(374, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 78),
(375, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 78),
(376, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 79),
(377, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 79),
(378, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 79),
(379, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 79),
(380, 'is_return', '1', 'integer', NULL, 'App\\Models\\Order', 79),
(381, 'btc_payment_sum', '0.000105', 'float', NULL, 'App\\Models\\Order', 79),
(382, 'timestamp', '1645631357', 'integer', NULL, 'App\\Models\\Order', 79),
(383, 'end_timestamp', '1645717757', 'integer', NULL, 'App\\Models\\Order', 79),
(384, 'shipped_note', 'Shipping info tex\r\n1\r\n1\r\n2\r\n\r\n2\r\n\r\n4\r\n5\r\n5\r\n5\r\n5', 'string', NULL, 'App\\Models\\Order', 79),
(385, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 80),
(386, 'shipping_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 80),
(387, 'billing_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 80),
(388, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 80),
(389, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 80),
(390, 'btc_payment_sum', '0.00003417', 'float', NULL, 'App\\Models\\Order', 80),
(391, 'timestamp', '1645799656', 'integer', NULL, 'App\\Models\\Order', 80),
(392, 'end_timestamp', '1645886056', 'integer', NULL, 'App\\Models\\Order', 80),
(393, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 81),
(394, 'shipping_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 81),
(395, 'billing_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 81),
(396, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 81),
(397, 'is_return', '1', 'integer', NULL, 'App\\Models\\Order', 81),
(398, 'btc_payment_sum', '0.00017226', 'float', NULL, 'App\\Models\\Order', 81),
(399, 'timestamp', '1645882460', 'integer', NULL, 'App\\Models\\Order', 81),
(400, 'end_timestamp', '1648042460', 'integer', NULL, 'App\\Models\\Order', 81),
(401, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 82),
(402, 'shipping_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 82),
(403, 'billing_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 82),
(404, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 82),
(405, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 82),
(406, 'btc_payment_sum', '0.00003491', 'float', NULL, 'App\\Models\\Order', 82),
(407, 'timestamp', '1646044253', 'integer', NULL, 'App\\Models\\Order', 82),
(408, 'end_timestamp', '1646130653', 'integer', NULL, 'App\\Models\\Order', 82),
(409, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 83),
(410, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 83),
(411, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 83);
INSERT INTO `meta_attributes` (`meta_id`, `meta_key`, `meta_value`, `meta_type`, `meta_group`, `metable_type`, `metable_id`) VALUES
(412, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 83),
(413, 'is_return', '1', 'integer', NULL, 'App\\Models\\Order', 83),
(414, 'btc_payment_sum', '0.000105', 'float', NULL, 'App\\Models\\Order', 83),
(415, 'timestamp', '1647102671', 'integer', NULL, 'App\\Models\\Order', 83),
(416, 'end_timestamp', '1647189071', 'integer', NULL, 'App\\Models\\Order', 83),
(417, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 84),
(418, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 84),
(419, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 84),
(420, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 84),
(421, 'is_return', '1', 'integer', NULL, 'App\\Models\\Order', 84),
(422, 'btc_payment_sum', '0.000105', 'float', NULL, 'App\\Models\\Order', 84),
(423, 'timestamp', '1647102727', 'integer', NULL, 'App\\Models\\Order', 84),
(424, 'end_timestamp', '1647189127', 'integer', NULL, 'App\\Models\\Order', 84),
(425, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 85),
(426, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 85),
(427, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 85),
(428, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 85),
(429, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 85),
(430, 'btc_payment_sum', '0.00002563', 'float', NULL, 'App\\Models\\Order', 85),
(431, 'timestamp', '1647257472', 'integer', NULL, 'App\\Models\\Order', 85),
(432, 'end_timestamp', '1647343872', 'integer', NULL, 'App\\Models\\Order', 85),
(433, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 86),
(434, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 86),
(435, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 86),
(436, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 86),
(437, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 86),
(438, 'btc_payment_sum', '0.00002563', 'float', NULL, 'App\\Models\\Order', 86),
(439, 'timestamp', '1647257495', 'integer', NULL, 'App\\Models\\Order', 86),
(440, 'end_timestamp', '1647343895', 'integer', NULL, 'App\\Models\\Order', 86),
(441, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 87),
(442, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 87),
(443, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 87),
(444, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 87),
(445, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 87),
(446, 'btc_payment_sum', '0.00002563', 'float', NULL, 'App\\Models\\Order', 87),
(447, 'timestamp', '1647257547', 'integer', NULL, 'App\\Models\\Order', 87),
(448, 'end_timestamp', '1647343947', 'integer', NULL, 'App\\Models\\Order', 87),
(449, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 88),
(450, 'shipping_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 88),
(451, 'billing_address', '{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 88),
(452, 'bd_type', 'prepayment', 'string', NULL, 'App\\Models\\Order', 88),
(453, 'is_return', '0', 'integer', NULL, 'App\\Models\\Order', 88),
(454, 'btc_payment_sum', '0.00002563', 'float', NULL, 'App\\Models\\Order', 88),
(455, 'timestamp', '1647257622', 'integer', NULL, 'App\\Models\\Order', 88),
(456, 'end_timestamp', '1647344022', 'integer', NULL, 'App\\Models\\Order', 88),
(457, 'user_choices', '[{"group":"general","name":"quantity","value":1}]', 'array', NULL, 'App\\Models\\Order', 89),
(458, 'shipping_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 89),
(459, 'billing_address', '{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"}', 'array', NULL, 'App\\Models\\Order', 89),
(460, 'bd_type', 'mediation', 'string', NULL, 'App\\Models\\Order', 89),
(461, 'is_return', '1', 'integer', NULL, 'App\\Models\\Order', 89),
(462, 'btc_payment_sum', '0.00016167', 'float', NULL, 'App\\Models\\Order', 89),
(463, 'timestamp', '1647510796', 'integer', NULL, 'App\\Models\\Order', 89),
(464, 'end_timestamp', '1650534796', 'integer', NULL, 'App\\Models\\Order', 89);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_08_15_180252_create_meta_table', 1),
(2, '2016_08_15_185912_create_plans_table', 1),
(3, '2016_08_15_190000_create_plan_features_table', 1),
(4, '2016_08_15_190033_create_plan_subscriptions_table', 1),
(5, '2016_08_15_190045_create_plan_subscription_usages_table', 1),
(6, '2017_03_04_000000_create_bans_table', 1),
(7, '2018_05_03_154820_create_categories_table', 1),
(8, '2018_05_03_154820_create_category_pricing_model_table', 1),
(9, '2018_05_03_154820_create_comments_table', 1),
(10, '2018_05_03_154820_create_conversations_table', 1),
(11, '2018_05_03_154820_create_favorites_table', 1),
(12, '2018_05_03_154820_create_filters_table', 1),
(13, '2018_05_03_154820_create_listing_additional_options_table', 1),
(14, '2018_05_03_154820_create_listing_booked_dates_table', 1),
(15, '2018_05_03_154820_create_listing_booked_times_table', 1),
(16, '2018_05_03_154820_create_listing_shipping_options_table', 1),
(17, '2018_05_03_154820_create_listing_variants_table', 1),
(18, '2018_05_03_154820_create_listings_table', 1),
(19, '2018_05_03_154820_create_ltm_translations_table', 1),
(20, '2018_05_03_154820_create_menus_table', 1),
(21, '2018_05_03_154820_create_messages_table', 1),
(22, '2018_05_03_154820_create_meta_attributes_table', 1),
(23, '2018_05_03_154820_create_orders_meta_table', 1),
(24, '2018_05_03_154820_create_orders_table', 1),
(25, '2018_05_03_154820_create_page_translations_table', 1),
(26, '2018_05_03_154820_create_pages_table', 1),
(27, '2018_05_03_154820_create_password_resets_table', 1),
(28, '2018_05_03_154820_create_payment_gateways_table', 1),
(29, '2018_05_03_154820_create_pricing_models_table', 1),
(30, '2018_05_03_154820_create_settings_table', 1),
(31, '2018_05_03_154820_create_users_meta_table', 1),
(32, '2018_05_03_154820_create_users_table', 1),
(33, '2018_05_03_154820_create_widgets_table', 1),
(34, '2018_05_03_154821_add_foreign_keys_to_users_meta_table', 1),
(35, '2018_06_29_032244_create_laravel_follow_tables', 1),
(36, '2018_07_05_090301_create_permission_tables', 1),
(37, '2018_07_05_152234_create_reported_listings_table', 1),
(38, '2018_07_21_151624_create_sessions_table', 1),
(39, '2018_07_23_123320_add_multiple_services_to_pricing_models', 1),
(40, '2018_07_23_144840_create_listing_services_table', 1),
(41, '2018_07_24_121759_add_duration_to_listing_booked_times', 1),
(42, '2018_08_28_160404_create_custom_files_table', 1),
(43, '2018_09_07_114850_add_trader_type_to_users_table', 1),
(44, '2018_09_07_114913_create_listing_plans', 1),
(45, '2018_09_07_114919_create_listing_plan_payments', 1),
(46, '2018_09_07_114926_create_payments', 1),
(47, '2018_09_10_145759_add_priority_to_listings_table', 1),
(48, '2018_09_19_192916_add_ip_to_orders_table', 1),
(49, '2018_09_20_113000_create_wallets_table', 1),
(50, '2018_09_20_113500_create_wallet_transactions_table', 1),
(51, '2018_11_13_161323_add_identity_verification_to_users_table', 1),
(52, '2018_11_23_133443_add_ends_at_to_listings_table', 1),
(53, '2018_12_24_194255_add_location_to_users_table', 1),
(54, '2018_12_27_100049_create_user_filters_table', 1),
(55, '2019_01_22_101707_add_advanced_to_page_translations_table', 1),
(56, '2019_02_09_123149_create_checkout_sessions_table', 1),
(57, '2019_02_09_124423_create_payment_providers_table', 1),
(58, '2019_02_28_215940_create_tag_tables', 1),
(59, '2019_03_08_174639_add_region_to_listings_table', 1),
(60, '2019_04_15_130804_add_quantities_to_additional_options_table', 1),
(61, '2019_05_30_145456_add_meta_to_categories_table', 1),
(62, '2019_07_05_165524_create_metatags_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE IF NOT EXISTS `model_has_permissions` (
  `permission_id` int unsigned NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE IF NOT EXISTS `model_has_roles` (
  `role_id` int unsigned NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(4, 'App\\Models\\User', 1),
(1, 'App\\Models\\User', 2),
(5, 'App\\Models\\User', 3),
(1, 'App\\Models\\User', 4),
(1, 'App\\Models\\User', 5),
(1, 'App\\Models\\User', 6),
(1, 'App\\Models\\User', 7),
(1, 'App\\Models\\User', 8),
(1, 'App\\Models\\User', 9),
(1, 'App\\Models\\User', 10),
(1, 'App\\Models\\User', 11),
(1, 'App\\Models\\User', 12),
(1, 'App\\Models\\User', 13),
(1, 'App\\Models\\User', 14),
(1, 'App\\Models\\User', 15),
(1, 'App\\Models\\User', 16),
(1, 'App\\Models\\User', 17),
(1, 'App\\Models\\User', 18),
(1, 'App\\Models\\User', 19),
(1, 'App\\Models\\User', 20),
(1, 'App\\Models\\User', 21),
(1, 'App\\Models\\User', 22),
(1, 'App\\Models\\User', 24),
(1, 'App\\Models\\User', 25),
(1, 'App\\Models\\User', 26),
(1, 'App\\Models\\User', 27);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  `seller_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `conversation_id` int NOT NULL DEFAULT '0',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'open',
  `amount` decimal(11,2) DEFAULT NULL,
  `service_fee` decimal(11,2) DEFAULT '0.00',
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `units` int DEFAULT NULL,
  `payment_gateway_id` int DEFAULT NULL,
  `processor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorization_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capture_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refund_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `listing_options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `choices` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `customer_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payment_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_until` datetime DEFAULT NULL,
  `accepted_at` datetime DEFAULT NULL,
  `declined_at` datetime DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `listing_id`, `seller_id`, `user_id`, `conversation_id`, `status`, `amount`, `service_fee`, `currency`, `units`, `payment_gateway_id`, `processor`, `authorization_id`, `capture_id`, `refund_id`, `reference`, `token`, `listing_options`, `choices`, `customer_details`, `payment_address`, `payment_until`, `accepted_at`, `declined_at`, `deleted_at`, `created_at`, `updated_at`, `ip_address`) VALUES
(1, 1, 1, 1, 8, 'accepted', 21.00, 6.00, 'GBP', NULL, NULL, NULL, 'kopKVQbNDw', NULL, NULL, NULL, NULL, '{"_token":"444SWBura9XGcYvWaHpkueU1GPvEFdzOS36MEzij","same_address":"1","payment_method":"1","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"}}', NULL, NULL, '', NULL, '1984-09-05 14:47:40', NULL, NULL, '2021-05-02 14:24:49', '2021-06-28 03:15:37', NULL),
(2, 1, 1, 2, 0, 'accepted', 135.00, 25.00, 'GBP', NULL, 1, 'offline', 'ywzKMLbn1P', NULL, NULL, NULL, NULL, '{"_token":"xnVDQF095ejKZ5BBnq3bKarezwcMQDPdmiIaoGup","variant":{"Size":"XL","Primary colour":"Blue"},"quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"123","city":"123","state":"123","address":"Test","country":null,"full_name":"Test"},"shipping_address":{"zip":null,"city":null,"state":null,"address":null,"country":null,"full_name":null}}', NULL, NULL, '', NULL, '2021-06-14 14:07:51', NULL, NULL, '2021-06-14 11:06:29', '2021-06-14 11:07:51', NULL),
(3, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z5oYy9YAq8', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 09:51:22', '2021-09-06 09:51:22', NULL),
(4, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'wEqKwe0RJo', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"4"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 09:54:49', '2021-09-06 09:54:49', NULL),
(5, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'raX0lybWB3', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"5"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 09:58:18', '2021-09-06 09:58:18', NULL),
(6, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'zNgY6Pbvke', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 10:00:53', '2021-09-06 10:00:53', NULL),
(7, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'zNgY6Pbvke', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 10:01:16', '2021-09-06 10:01:16', NULL),
(8, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'zNgY6Pbvke', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 10:02:49', '2021-09-06 10:02:49', NULL),
(9, 1, 1, 1, 10, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'zNgY6Pbvke', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-09-06 10:04:03', '2021-09-06 10:04:03', NULL),
(10, 1, 1, 1, 11, 'accepted', 41.00, 0.00, 'GBP', NULL, 1, 'offline', '3dj0zXKlze', NULL, NULL, NULL, NULL, '{"_token":"8AwPi46NVeeqr027TkansXVLcE3heQGBM8aAls7G","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"4"}', NULL, NULL, '', NULL, '2021-09-15 10:54:24', NULL, NULL, '2021-09-06 10:05:35', '2021-09-15 07:54:24', NULL),
(11, 1, 1, 1, 12, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'yaMbj6bO8J', NULL, NULL, NULL, NULL, '{"_token":"z1fd6eDRzFxOeZVjiTPEIusvjnzC4yaf9Ur22OmL","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-19 12:53:32', '2021-10-19 12:53:32', NULL),
(12, 1, 1, 1, 13, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'yaMbj6bO8J', NULL, NULL, NULL, NULL, '{"_token":"z1fd6eDRzFxOeZVjiTPEIusvjnzC4yaf9Ur22OmL","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-20 08:25:41', '2021-10-20 08:25:41', NULL),
(13, 1, 1, 1, 14, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'yaMbj6bO8J', NULL, NULL, NULL, NULL, '{"_token":"z1fd6eDRzFxOeZVjiTPEIusvjnzC4yaf9Ur22OmL","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-20 12:18:02', '2021-10-20 12:18:02', NULL),
(14, 1, 1, 1, 15, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'wgPbEzKG8R', NULL, NULL, NULL, NULL, '{"_token":"w5rrEAM3DAs0ZOtXUoRzzRImMLaP3BxSfWgAUSVR","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-22 08:54:30', '2021-10-22 08:54:30', NULL),
(15, 1, 1, 1, 16, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'wgPbEzKG8R', NULL, NULL, NULL, NULL, '{"_token":"w5rrEAM3DAs0ZOtXUoRzzRImMLaP3BxSfWgAUSVR","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-22 08:54:57', '2021-10-22 08:54:57', NULL),
(16, 1, 1, 1, 17, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'wgPbEzKG8R', NULL, NULL, NULL, NULL, '{"_token":"w5rrEAM3DAs0ZOtXUoRzzRImMLaP3BxSfWgAUSVR","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-22 08:56:20', '2021-10-22 08:56:20', NULL),
(17, 1, 1, 1, 18, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'yaMbj6bO8J', NULL, NULL, NULL, NULL, '{"_token":"z1fd6eDRzFxOeZVjiTPEIusvjnzC4yaf9Ur22OmL","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-22 11:13:16', '2021-10-22 11:13:16', NULL),
(18, 1, 1, 1, 19, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'w2d0GyKmXj', NULL, NULL, NULL, NULL, '{"_token":"w5rrEAM3DAs0ZOtXUoRzzRImMLaP3BxSfWgAUSVR","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"3"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-10-22 13:15:34', '2021-10-22 13:15:34', NULL),
(19, 1, 1, 1, 20, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', '1albWV06rW', NULL, NULL, NULL, NULL, '{"_token":"YJsf4m695ihpFEDKPJ7FyZl0HGXk3mdwlEhwUtFT","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"3"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-04 14:30:11', '2021-11-04 14:30:11', NULL),
(20, 1, 1, 1, 21, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', '1albWV06rW', NULL, NULL, NULL, NULL, '{"_token":"YJsf4m695ihpFEDKPJ7FyZl0HGXk3mdwlEhwUtFT","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"3"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-10 09:53:39', '2021-11-10 09:53:39', NULL),
(21, 1, 1, 1, 22, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-20 14:31:21', '2021-11-20 14:31:21', NULL),
(22, 1, 1, 1, 23, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-20 14:33:52', '2021-11-20 14:33:52', NULL),
(23, 1, 1, 1, 24, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-20 14:35:41', '2021-11-20 14:35:41', NULL),
(24, 1, 1, 1, 25, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-20 14:37:36', '2021-11-20 14:37:36', NULL),
(25, 1, 1, 1, 26, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-20 14:41:06', '2021-11-20 14:41:06', NULL),
(26, 1, 1, 1, 27, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-22 13:31:16', '2021-11-22 13:31:16', NULL),
(27, 1, 1, 1, 28, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-24 14:39:58', '2021-11-24 14:39:58', NULL),
(28, 1, 1, 1, 29, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'Z1n0eNbpOE', NULL, NULL, NULL, NULL, '{"_token":"CcMlAbugcv376RTkPDY1qda3aAyumF20L2b1pZBS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, '', NULL, NULL, NULL, NULL, '2021-11-26 07:44:15', '2021-11-26 07:44:15', NULL),
(29, 1, 1, 1, 30, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'LBrYOD0A61', NULL, NULL, NULL, NULL, '{"_token":"c1lbDQm0ace0XTwV76U38aQ8dEKNNOMWzivrLhh3","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"3"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-03 17:38:27', NULL, NULL, NULL, '2021-11-30 15:38:26', '2021-11-30 15:38:27', NULL),
(30, 1, 1, 1, 31, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'LBrYOD0A61', NULL, NULL, NULL, NULL, '{"_token":"c1lbDQm0ace0XTwV76U38aQ8dEKNNOMWzivrLhh3","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"3"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2021-12-03 17:40:26', NULL, NULL, NULL, '2021-11-30 15:40:26', '2021-11-30 15:40:26', NULL),
(31, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:53:20', '2021-12-09 14:53:20', NULL),
(32, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:54:53', '2021-12-09 14:54:53', NULL),
(33, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:55:29', '2021-12-09 14:55:29', NULL),
(34, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:55:47', '2021-12-09 14:55:47', NULL),
(35, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:56:13', '2021-12-09 14:56:13', NULL),
(36, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:56:34', '2021-12-09 14:56:34', NULL),
(37, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:56:52', '2021-12-09 14:56:52', NULL),
(38, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:57:11', '2021-12-09 14:57:11', NULL),
(39, 1, 1, 1, 0, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2021-12-09 14:57:25', '2021-12-09 14:57:25', NULL),
(40, 1, 1, 1, 32, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1q60sk7k78a7l0v7e4k3kp3p4qf4vssyv9jk2ajv', '2021-12-09 22:00:53', NULL, NULL, NULL, '2021-12-09 15:00:53', '2021-12-09 15:00:54', NULL),
(41, 1, 1, 1, 33, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qxwvkedt790cg7h5v92g5khw8072za5syt9jc5a', '2021-12-09 22:01:50', NULL, NULL, NULL, '2021-12-09 15:01:50', '2021-12-09 15:01:50', NULL),
(42, 1, 1, 1, 34, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qfyruc78fqscfurgdvyy3c5jqu5g5764d5zpkxf', '2021-12-09 22:07:41', NULL, NULL, NULL, '2021-12-09 15:07:41', '2021-12-09 15:07:41', NULL),
(43, 1, 1, 1, 35, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qmwcd8mk79llzs59dcpsu7tp8d42vf8pt5ksq8p', '2021-12-09 22:13:48', NULL, NULL, NULL, '2021-12-09 15:13:48', '2021-12-09 15:13:48', NULL),
(44, 1, 1, 1, 36, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qklwqkk84wr30etc29l6vwhueq2uxjt9pat4k04', '2021-12-09 22:14:25', NULL, NULL, NULL, '2021-12-09 15:14:25', '2021-12-09 15:14:25', NULL),
(45, 1, 1, 1, 37, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qpmfya344ca0tet4tpvn4tdwkx4w22vrkj8mnlw', '2021-12-09 22:15:08', NULL, NULL, NULL, '2021-12-09 15:15:07', '2021-12-09 15:15:08', NULL),
(46, 1, 1, 1, 38, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qq6cdhfz5yzz3qhcfz56sc5mm02nhwgh0xzf6rf', '2021-12-09 22:17:48', NULL, NULL, NULL, '2021-12-09 15:17:48', '2021-12-09 15:17:48', NULL),
(47, 1, 1, 1, 39, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qcvjerv0qx5lndupa59e593mhl7zqgt57f7j9zp', '2021-12-09 22:18:37', NULL, NULL, NULL, '2021-12-09 15:18:36', '2021-12-09 15:18:37', NULL),
(48, 1, 1, 1, 40, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1q5nakzxuhv24ax5ed8sxg88eqxw22yfsyhsszz6', '2021-12-09 22:19:27', NULL, NULL, NULL, '2021-12-09 15:19:26', '2021-12-09 15:19:27', NULL),
(49, 1, 1, 1, 41, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qndh3laxy04upgn63nmaunjjew3shuhlkfuk8du', '2021-12-09 22:19:43', NULL, NULL, NULL, '2021-12-09 15:19:42', '2021-12-09 15:19:43', NULL),
(50, 1, 1, 1, 42, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qeehfph5ukvdecjr6p5uzdldh23kukkwfctesvl', '2021-12-09 22:20:18', NULL, NULL, NULL, '2021-12-09 15:20:18', '2021-12-09 15:20:18', NULL),
(51, 1, 1, 1, 43, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qcxz44u5xqhlc3vkvjfgugkv8p4wejq2rqdjrdu', '2021-12-09 22:22:16', NULL, NULL, NULL, '2021-12-09 15:22:15', '2021-12-09 15:22:16', NULL),
(52, 1, 1, 1, 44, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qngdh20ta9ejsjh478ar2mfh3kjfzzjp8hg5ukk', '2021-12-09 22:23:20', NULL, NULL, NULL, '2021-12-09 15:23:20', '2021-12-09 15:23:20', NULL),
(53, 1, 1, 1, 45, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1q2daxmncqk5y7dx9gj86admux0pjc08rnerx0f2', '2021-12-09 22:24:52', NULL, NULL, NULL, '2021-12-09 15:24:52', '2021-12-09 15:24:52', NULL),
(54, 1, 1, 1, 46, 'dispute', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qau3jy0d78v7w0s9c0crxkguk2wwrf3nqrkt08u', '2021-12-09 22:25:45', NULL, NULL, NULL, '2021-12-09 15:25:44', '2021-12-13 13:20:52', NULL),
(55, 1, 1, 5, 47, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'LRMYmeYBG5', NULL, NULL, NULL, NULL, '{"_token":"2j7iQiq3TOoA3Y9Yl3q6puxFKgT9670Aul0xF9SF","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":null,"state":null,"address":null,"country":"US","full_name":"Tester"},"shipping_option":"4"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-15 15:18:59', NULL, NULL, NULL, '2021-12-15 08:18:58', '2021-12-15 08:18:59', NULL),
(56, 1, 1, 1, 48, 'open', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'JMmK1qKlwV', NULL, NULL, NULL, NULL, '{"_token":"OHd3GQxr6Vx9j2TIwYIYzJfm6BKv7ZS3mzjBFBPG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"test","state":"test","address":"Test","country":"RU","full_name":"Test"},"shipping_option":"2"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-15 17:52:36', NULL, NULL, NULL, '2021-12-15 10:52:36', '2021-12-15 10:52:36', NULL),
(57, 1, 1, 6, 49, 'accepted', 41.00, 0.00, 'GBP', NULL, 1, 'offline', 'QEBb2BbyoJ', NULL, NULL, NULL, NULL, '{"_token":"UZoHsSqbArnfgy9F9o0CeUjlCUbEWSWtjTqiBufV","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":null,"address":"Home Street, My House","country":"US","full_name":"James"},"shipping_option":"4"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-16 16:32:58', '2021-12-16 11:57:26', NULL, NULL, '2021-12-16 09:32:58', '2021-12-16 09:57:26', NULL),
(58, 1, 1, 1, 50, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', '6qj0xzKLN3', NULL, NULL, NULL, NULL, '{"_token":"wA1e0S5cCYlfnDjS89iXw77SCd5wtWtvCjGSfoFS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"5"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-20 16:06:50', NULL, NULL, NULL, '2021-12-20 09:06:50', '2021-12-20 09:06:50', NULL),
(59, 1, 1, 1, 51, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'mOD0g705ql', NULL, NULL, NULL, NULL, '{"_token":"wA1e0S5cCYlfnDjS89iXw77SCd5wtWtvCjGSfoFS","quantity":"2","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"4"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2021-12-20 16:17:36', NULL, NULL, NULL, '2021-12-20 09:17:35', '2021-12-20 09:17:36', NULL),
(60, 1, 1, 8, 52, 'accepted', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'EoqKpxKvA2', NULL, NULL, NULL, NULL, '{"_token":"xd4z3ta6a8A9JMnQkKbPR8HTCPOhENcEn0FF06jt","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"},"shipping_option":"2"}', NULL, NULL, 'tb1qc05zj3pylg7y4mny689htmcf482p4mm8j6gwkn', '2021-12-20 16:25:29', '2021-12-20 11:30:33', '2021-12-20 11:29:33', NULL, '2021-12-20 09:25:28', '2021-12-20 09:30:33', NULL),
(61, 1, 1, 1, 53, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', '9lA0qa0WE2', NULL, NULL, NULL, NULL, '{"_token":"wA1e0S5cCYlfnDjS89iXw77SCd5wtWtvCjGSfoFS","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"4"}', NULL, NULL, 'tb1qva6ft0k6m3qyyvwtumag05vmyxzt5gvhrxdgfu', '2021-12-22 16:31:04', NULL, NULL, NULL, '2021-12-20 09:31:03', '2021-12-20 09:31:04', NULL),
(62, 1, 1, 8, 54, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', '3DnKBebPdk', NULL, NULL, NULL, NULL, '{"_token":"xd4z3ta6a8A9JMnQkKbPR8HTCPOhENcEn0FF06jt","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"city","state":"state","address":"address","country":"RU","full_name":"name"},"shipping_option":"2"}', NULL, NULL, 'tb1qjhau78u8shycgjsrv0cksvfuwwyfpckaukv7g6', '2021-12-20 16:34:42', NULL, NULL, NULL, '2021-12-20 09:34:42', '2021-12-20 09:34:42', NULL),
(63, 1, 1, 1, 55, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'pN4K5Lbl86', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-22 20:33:49', NULL, NULL, NULL, '2021-12-22 13:33:49', '2021-12-22 13:33:49', NULL),
(64, 1, 1, 1, 56, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2021-12-22 20:40:07', NULL, NULL, NULL, '2021-12-22 13:40:07', '2021-12-22 13:40:07', NULL),
(65, 1, 1, 1, 57, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qc05zj3pylg7y4mny689htmcf482p4mm8j6gwkn', '2021-12-22 20:42:16', NULL, NULL, NULL, '2021-12-22 13:42:16', '2021-12-22 13:42:16', NULL),
(66, 1, 1, 1, 58, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qva6ft0k6m3qyyvwtumag05vmyxzt5gvhrxdgfu', '2021-12-22 20:42:39', NULL, NULL, NULL, '2021-12-22 13:42:39', '2021-12-22 13:42:39', NULL),
(67, 1, 1, 1, 59, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qjhau78u8shycgjsrv0cksvfuwwyfpckaukv7g6', '2021-12-22 20:43:20', NULL, NULL, NULL, '2021-12-22 13:43:19', '2021-12-22 13:43:20', NULL),
(68, 1, 1, 1, 60, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qkfhzwwkl5zd3t64cpajct7dqq5p7h6y0m3ag73', '2021-12-22 20:43:36', NULL, NULL, NULL, '2021-12-22 13:43:36', '2021-12-22 13:43:36', NULL),
(69, 1, 1, 1, 61, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qdj6942ygkaandvchhf2nt0m49ah4xctpntf3cm', '2021-12-22 20:44:29', NULL, NULL, NULL, '2021-12-22 13:44:29', '2021-12-22 13:44:29', NULL),
(70, 1, 1, 1, 62, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qtc5cl2737g9dze2tenyy7hphy8zyhk0yxydguf', '2021-12-22 20:45:15', NULL, NULL, NULL, '2021-12-22 13:45:14', '2021-12-22 13:45:15', NULL),
(71, 1, 1, 1, 63, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1q44ezh7u28wc5k568mazsyey2tv7urtg4lrkk7a', '2021-12-22 20:46:45', NULL, NULL, NULL, '2021-12-22 13:46:44', '2021-12-22 13:46:45', NULL),
(72, 1, 1, 1, 64, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1q60sk7k78a7l0v7e4k3kp3p4qf4vssyv9jk2ajv', '2021-12-22 20:47:23', NULL, NULL, NULL, '2021-12-22 13:47:22', '2021-12-22 13:47:23', NULL),
(73, 1, 1, 1, 65, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qxwvkedt790cg7h5v92g5khw8072za5syt9jc5a', '2021-12-22 20:48:42', NULL, NULL, NULL, '2021-12-22 13:48:42', '2021-12-22 13:48:42', NULL),
(74, 1, 1, 1, 66, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'r4W0JdKQJ8', NULL, NULL, NULL, NULL, '{"_token":"OqzCMajvqq6DMg9qgcup2u2qg0FrqsROEOtjAuiH","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"RU","full_name":"Full Name"},"shipping_option":"3"}', NULL, NULL, 'tb1qfyruc78fqscfurgdvyy3c5jqu5g5764d5zpkxf', '2021-12-22 20:55:20', NULL, NULL, NULL, '2021-12-22 13:55:20', '2021-12-22 13:55:20', NULL),
(75, 1, 1, 15, 67, 'open', 41.00, 0.00, 'GBP', NULL, 2, 'offline', 'donbZa057P', NULL, NULL, NULL, NULL, '{"_token":"4tEIfbdH4Z7vAGwsuIgu1G2zITC9N0gyG2WxQhit","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"u5-City","state":"u5-State","address":"u5-Home","country":"BS","full_name":"u5"},"shipping_option":"5"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-23 16:36:33', NULL, NULL, NULL, '2021-12-23 09:36:33', '2021-12-23 09:36:33', NULL),
(76, 6, 1, 18, 0, 'open', 2.50, 0.00, 'GBP', NULL, 2, 'offline', 'oz4YkAbyrn', NULL, NULL, NULL, NULL, '{"_token":"gtEU2ubQ0oXSvy39OiBFw33ZzCFvjKndfiJqQXib","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"MyCity","state":"MyState","address":"MyAddress","country":"US","full_name":"u08"},"shipping_option":"7"}', NULL, NULL, 'tb1qncggslcfkek50takj73matumr6x7t5spd7uqhw', '2021-12-29 16:04:50', NULL, NULL, NULL, '2021-12-29 09:04:50', '2021-12-29 09:04:50', NULL),
(77, 28, 25, 21, 68, 'open', 1.00, 0.00, 'USD', NULL, 2, 'offline', 'ajVYRnYAZO', NULL, NULL, NULL, NULL, '{"_token":"xyaRNVZh5VDF4GTStvXTmrR5hFkdYbqBOoQi8nMd","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"17"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-01-18 17:12:07', NULL, NULL, NULL, '2022-01-18 10:12:07', '2022-01-18 10:12:07', NULL),
(78, 30, 1, 1, 0, 'open', 327.64, 0.00, 'RUB', NULL, 2, 'offline', 'xQ6KdZ08wG', NULL, NULL, NULL, NULL, '{"_token":"7hqaunFAZTXvbU2jr4oHFBBF6D0lZHAyVYwDFpLC","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"23"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2022-02-23 13:45:24', '2022-02-23 13:45:24', NULL),
(79, 30, 1, 1, 69, 'shipped', 327.64, 0.00, 'RUB', NULL, 2, 'offline', 'xQ6KdZ08wG', NULL, NULL, NULL, NULL, '{"_token":"7hqaunFAZTXvbU2jr4oHFBBF6D0lZHAyVYwDFpLC","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"23"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-02-23 20:49:17', '2022-02-23 16:19:31', NULL, NULL, '2022-02-23 13:49:16', '2022-02-23 14:25:00', NULL),
(80, 33, 25, 21, 70, 'open', 1.00, 0.00, 'GBP', NULL, 2, 'offline', 'argbvLYod1', NULL, NULL, NULL, NULL, '{"_token":"rd8KyJK5vpRFNXreN5863Cb0NRYCLVfxr0zebags","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"27"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-02-25 19:34:16', NULL, NULL, NULL, '2022-02-25 12:34:16', '2022-02-25 12:34:16', NULL),
(81, 34, 25, 21, 0, 'open', 5.00, 0.00, 'GBP', NULL, 2, 'offline', 'X4Vb9X09Nj', NULL, NULL, NULL, NULL, '{"_token":"Ybfv4xEluOfyQX05pnfDNN4kv7OuJfsADvb32k2C","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"29"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-02-26 18:34:20', NULL, NULL, NULL, '2022-02-26 11:34:20', '2022-02-26 11:34:20', NULL),
(82, 33, 25, 21, 71, 'open', 1.00, 0.00, 'GBP', NULL, 2, 'offline', 'yZQb4eKLgv', NULL, NULL, NULL, NULL, '{"_token":"dGll7mnvaHUqMxHImsI8NU3c1d0tF7vm1DWFPBqG","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"27"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-02-28 15:30:53', NULL, NULL, NULL, '2022-02-28 08:30:53', '2022-02-28 08:30:53', NULL),
(83, 30, 1, 1, 72, 'open', 550.38, 0.00, 'RUB', NULL, 2, 'offline', 'N3EYA3bD9o', NULL, NULL, NULL, NULL, '{"_token":"9LghH3AAM5m4Qc9f9FBqegG9PBHqiv9AxcwW31gb","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"23"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-03-12 21:31:11', NULL, NULL, NULL, '2022-03-12 14:31:11', '2022-03-12 14:31:11', NULL),
(84, 30, 1, 1, 73, 'open', 550.38, 0.00, 'RUB', NULL, 2, 'offline', 'N3EYA3bD9o', NULL, NULL, NULL, NULL, '{"_token":"9LghH3AAM5m4Qc9f9FBqegG9PBHqiv9AxcwW31gb","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"23"}', NULL, NULL, 'tb1qc05zj3pylg7y4mny689htmcf482p4mm8j6gwkn', '2022-03-12 21:32:07', NULL, NULL, NULL, '2022-03-12 14:32:07', '2022-03-12 14:32:07', NULL),
(85, 29, 25, 1, 74, 'open', 1.00, 0.00, 'USD', NULL, 2, 'offline', 'L1kbrZbjP6', NULL, NULL, NULL, NULL, '{"_token":"mzbH0FCCBBVeENZYsT1y0KExdfIiqStfNuwOoqRZ","quantity":"10","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"21"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-03-14 16:31:12', NULL, NULL, NULL, '2022-03-14 09:31:12', '2022-03-14 09:31:12', NULL),
(86, 29, 25, 1, 75, 'open', 1.00, 0.00, 'USD', NULL, 2, 'offline', 'L1kbrZbjP6', NULL, NULL, NULL, NULL, '{"_token":"mzbH0FCCBBVeENZYsT1y0KExdfIiqStfNuwOoqRZ","quantity":"10","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"21"}', NULL, NULL, 'tb1qc05zj3pylg7y4mny689htmcf482p4mm8j6gwkn', '2022-03-14 16:31:35', NULL, NULL, NULL, '2022-03-14 09:31:35', '2022-03-14 09:31:35', NULL),
(87, 29, 25, 1, 76, 'open', 1.00, 0.00, 'USD', NULL, 2, 'offline', 'L1kbrZbjP6', NULL, NULL, NULL, NULL, '{"_token":"mzbH0FCCBBVeENZYsT1y0KExdfIiqStfNuwOoqRZ","quantity":"10","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"21"}', NULL, NULL, 'tb1qva6ft0k6m3qyyvwtumag05vmyxzt5gvhrxdgfu', '2022-03-14 16:32:27', NULL, NULL, NULL, '2022-03-14 09:32:27', '2022-03-14 09:32:27', NULL),
(88, 29, 25, 1, 77, 'open', 1.00, 0.00, 'USD', NULL, 2, 'offline', 'L1kbrZbjP6', NULL, NULL, NULL, NULL, '{"_token":"mzbH0FCCBBVeENZYsT1y0KExdfIiqStfNuwOoqRZ","quantity":"10","same_address":"1","payment_method":"offline","billing_address":{"zip":"000000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"21"}', NULL, NULL, 'tb1qjhau78u8shycgjsrv0cksvfuwwyfpckaukv7g6', '2022-03-14 16:33:42', NULL, NULL, NULL, '2022-03-14 09:33:42', '2022-03-14 09:33:42', NULL),
(89, 34, 25, 21, 0, 'open', 5.00, 0.00, 'GBP', NULL, 2, 'offline', '6W2Y7D019l', NULL, NULL, NULL, NULL, '{"_token":"P3PcO7IoytFwg2mUc7j6NR36gvzvt0UmaKpehLH0","quantity":"1","same_address":"1","payment_method":"offline","billing_address":{"zip":"1020000","city":"City","state":"State","address":"Address","country":"US","full_name":"Full Name"},"shipping_option":"30"}', NULL, NULL, 'tb1q9uxea8wx2ne0p0g77aqxg9n34lygqdm0x0d972', '2022-03-17 14:53:16', NULL, NULL, NULL, '2022-03-17 07:53:15', '2022-03-17 07:53:16', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `orders_meta`
--

CREATE TABLE IF NOT EXISTS `orders_meta` (
  `id` int unsigned NOT NULL,
  `order_id` int unsigned NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'null',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE IF NOT EXISTS `pages` (
  `id` int NOT NULL,
  `template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_translations`
--

CREATE TABLE IF NOT EXISTS `page_translations` (
  `id` int unsigned NOT NULL,
  `locale` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `route` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `raw_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `seo_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_meta_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_meta_keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `extra_attributes` json DEFAULT NULL,
  `is_advanced` tinyint(1) DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `page_translations`
--

INSERT INTO `page_translations` (`id`, `locale`, `title`, `slug`, `route`, `content`, `raw_content`, `seo_title`, `seo_meta_description`, `seo_meta_keywords`, `visible`, `extra_attributes`, `is_advanced`, `published_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'US', 'Home', '/', NULL, '<p>Hello World!</p>', NULL, 'Home', NULL, NULL, 1, NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-04-17 13:45:22', NULL),
(2, 'US', 'Help', 'help', NULL, '<h4>What is this marketplace about?</h4>\r\n<p>Tell the user what the website is about</p>\r\n<h4>What can I sell?</h4>\r\n<p>Tell sellers what how they can use the website</p>\r\n<h4>What can I buy?</h4>\r\n<p>Tell buyers how they can use the website</p>', NULL, 'For sale', 'For sale meta', 'houses for sale, yes', 1, NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-04-17 13:45:44', NULL),
(3, 'US', 'About us', 'about', NULL, '<p>Enter your about us text here</p>\r\n<p><strong>Some Text</strong></p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>', NULL, 'About us', 'Seo meta description', 'Seo meta keywords', 1, NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-12-20 08:21:32', NULL),
(4, 'US', 'Terms and conditions', 'terms-and-conditions', NULL, '<p>Enter your terms and conditions here.</p>', NULL, 'Terms and conditions', NULL, NULL, 1, NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-04-17 13:47:04', NULL),
(5, 'US', 'Privacy policy', 'privacy-policy', NULL, '<p>Enter your privacy policy here</p>', NULL, 'Privacy policy', NULL, NULL, 1, NULL, NULL, NULL, '2021-03-12 00:56:53', '2021-04-17 13:47:11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('1641298847@localhost.loc', '$2y$10$txf5FxVjqAA5PTSdavN5wOaZg43p0cZMprWoawVVTL6rwEgvyvVNK', '2022-01-04 15:06:56'),
('mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw@mail.com', '$2y$10$N2Ch0qN5jTEgMjjgZ4cqe.cRIZ8eAW.8eXDTr0gCPCjhyKKR.3hqu', '2022-01-06 09:54:48'),
('1643019031@localhost.loc', '$2y$10$GbRmfeXyTOrd6fgRZqacMOnLdhpSbt2tgcdo/30lR8EDWc6toHMO6', '2022-02-21 12:47:23');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int unsigned NOT NULL,
  `processor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payable_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateways`
--

CREATE TABLE IF NOT EXISTS `payment_gateways` (
  `id` int NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_gateways`
--

INSERT INTO `payment_gateways` (`id`, `user_id`, `name`, `gateway_id`, `token`, `metadata`, `created_at`, `updated_at`) VALUES
(2, 1, 'offline', 'offline_1', NULL, NULL, '2021-12-20 09:05:47', '2021-12-20 09:05:47'),
(3, 20, 'offline', 'offline_20', NULL, NULL, '2022-01-06 06:58:57', '2022-01-06 06:58:57'),
(4, 21, 'offline', 'offline_21', NULL, NULL, '2022-01-06 07:00:26', '2022-01-06 07:00:26'),
(5, 25, 'offline', 'offline_25', NULL, NULL, '2022-01-06 09:11:46', '2022-01-06 09:11:46'),
(6, 22, 'offline', 'offline_22', NULL, NULL, '2022-01-18 08:09:56', '2022-01-18 08:09:56'),
(7, 26, 'offline', 'offline_26', NULL, NULL, '2022-02-21 13:56:38', '2022-02-21 13:56:38'),
(8, 27, 'offline', 'offline_27', NULL, NULL, '2022-02-28 08:45:38', '2022-02-28 08:45:38');

-- --------------------------------------------------------

--
-- Table structure for table `payment_providers`
--

CREATE TABLE IF NOT EXISTS `payment_providers` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `display_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payment_instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `client_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `connection_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT '0',
  `is_offline` tinyint(1) DEFAULT '0',
  `is_enabled` tinyint(1) DEFAULT NULL,
  `extra_attributes` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_providers`
--

INSERT INTO `payment_providers` (`id`, `name`, `key`, `icon`, `display_name`, `description`, `payment_instructions`, `client_id`, `client_secret`, `connection_url`, `position`, `is_offline`, `is_enabled`, `extra_attributes`, `created_at`, `updated_at`) VALUES
(1, 'Bitcoin', 'offline', 'bitcoin', 'Bitcoin', 'Bitcoin', 'Pay me to an External payment system', NULL, NULL, NULL, 0, 1, 1, NULL, '2021-05-02 14:06:08', '2021-12-20 08:23:45');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'edit listing', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(2, 'publish listing', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(3, 'unpublish listing', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(4, 'disable listing', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(5, 'ban user', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(6, 'edit order', 'web', '2021-05-31 21:00:00', '2021-05-31 21:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE IF NOT EXISTS `plans` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(7,2) NOT NULL DEFAULT '0.00',
  `interval` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'month',
  `interval_count` smallint NOT NULL DEFAULT '1',
  `trial_period_days` smallint DEFAULT NULL,
  `sort_order` smallint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plans`
--

INSERT INTO `plans` (`id`, `name`, `description`, `price`, `interval`, `interval_count`, `trial_period_days`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'Free', NULL, 0.00, 'month', 1, 0, NULL, '2018-09-11 12:28:59', '2018-09-19 16:55:48'),
(2, 'Standard', NULL, 14.99, 'month', 1, 0, NULL, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(3, 'Business', NULL, 49.99, 'month', 1, 0, NULL, '2018-09-11 12:29:52', '2018-09-11 12:29:52');

-- --------------------------------------------------------

--
-- Table structure for table `plan_features`
--

CREATE TABLE IF NOT EXISTS `plan_features` (
  `id` int unsigned NOT NULL,
  `plan_id` int unsigned NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` smallint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plan_features`
--

INSERT INTO `plan_features` (`id`, `plan_id`, `code`, `value`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 1, 'listings', '1', 1, '2018-09-11 12:28:59', '2018-09-11 12:28:59'),
(2, 1, 'images', '1', 5, '2018-09-11 12:28:59', '2018-09-11 12:28:59'),
(3, 1, 'featured_listings', '0', 15, '2018-09-11 12:28:59', '2018-09-11 12:28:59'),
(4, 1, 'messages', '3', 20, '2018-09-11 12:28:59', '2018-09-11 12:28:59'),
(5, 1, 'bold_listings', '0', 25, '2018-09-11 12:28:59', '2018-09-11 12:28:59'),
(6, 2, 'listings', '10', 1, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(7, 2, 'images', '10', 5, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(8, 2, 'featured_listings', '2', 15, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(9, 2, 'messages', '30', 20, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(10, 2, 'bold_listings', '2', 25, '2018-09-11 12:29:28', '2018-09-11 12:29:28'),
(11, 3, 'listings', '100', 1, '2018-09-11 12:29:52', '2018-09-11 12:30:03'),
(12, 3, 'images', '20', 5, '2018-09-11 12:29:52', '2018-09-11 12:29:52'),
(13, 3, 'featured_listings', '10', 15, '2018-09-11 12:29:52', '2018-09-11 12:29:52'),
(14, 3, 'messages', '300', 20, '2018-09-11 12:29:52', '2018-09-11 12:29:52'),
(15, 3, 'bold_listings', '10', 25, '2018-09-11 12:29:52', '2018-09-11 12:29:52');

-- --------------------------------------------------------

--
-- Table structure for table `plan_subscriptions`
--

CREATE TABLE IF NOT EXISTS `plan_subscriptions` (
  `id` int unsigned NOT NULL,
  `subscribable_id` int unsigned NOT NULL,
  `subscribable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `canceled_immediately` tinyint(1) DEFAULT NULL,
  `trial_ends_at` timestamp NULL DEFAULT NULL,
  `starts_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `canceled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `plan_subscription_usages`
--

CREATE TABLE IF NOT EXISTS `plan_subscription_usages` (
  `id` int unsigned NOT NULL,
  `subscription_id` int unsigned NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `used` smallint unsigned NOT NULL,
  `valid_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pricing_models`
--

CREATE TABLE IF NOT EXISTS `pricing_models` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seller_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `widget` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_display` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'unit' COMMENT 'unit/duration',
  `breakdown_display` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'unit' COMMENT 'unit/duration',
  `quantity_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'quantity',
  `can_accept_payments` tinyint(1) DEFAULT '0',
  `can_add_variants` tinyint(1) DEFAULT '0',
  `can_add_shipping` tinyint(1) DEFAULT '0',
  `can_add_pricing` tinyint(1) DEFAULT '0',
  `can_add_additional_pricing` tinyint(1) DEFAULT '0',
  `requires_shipping_address` tinyint(1) DEFAULT '0',
  `requires_billing_address` tinyint(1) DEFAULT '0',
  `meta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `can_list_multiple_services` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pricing_models`
--

INSERT INTO `pricing_models` (`id`, `name`, `seller_label`, `widget`, `unit_name`, `duration_name`, `price_display`, `breakdown_display`, `quantity_label`, `can_accept_payments`, `can_add_variants`, `can_add_shipping`, `can_add_pricing`, `can_add_additional_pricing`, `requires_shipping_address`, `requires_billing_address`, `meta`, `created_at`, `updated_at`, `can_list_multiple_services`) VALUES
(1, 'Prepayment', 'Prepayment', 'buy', 'item', NULL, 'unit', 'unit', 'quantity', 1, 0, 0, 1, 0, 1, 0, '{"per_label_buyer":null,"quantity_label_buyer":null,"can_seller_enter_per_label":false,"bd_type":"prepayment"}', '2021-03-12 00:56:53', '2021-12-10 12:17:46', 0),
(2, 'Mediation', 'Mediation', 'buy', 'item', NULL, 'unit', 'unit', 'quantity', 1, 0, 0, 1, 0, 1, 0, '{"per_label_buyer":null,"quantity_label_buyer":null,"can_seller_enter_per_label":false,"bd_type":"mediation"}', '2021-03-12 00:56:53', '2022-02-21 11:22:10', 0),
(3, 'Postpayment', 'Postpayment', 'buy', 'item', NULL, 'unit', 'unit', 'quantity', 1, 0, 0, 1, 0, 1, 0, '{"per_label_buyer":null,"quantity_label_buyer":null,"can_seller_enter_per_label":false,"bd_type":"postpayment"}', '2021-03-12 00:56:53', '2021-12-10 12:18:33', 0),
(4, 'Book Session', 'List your service', 'book_time', 'place', 'session', 'duration', 'unit', 'Spaces per session', 0, 0, 0, 0, 0, 0, 0, NULL, '2021-03-12 00:56:53', '2021-03-12 00:56:53', 0),
(5, 'Rent Item', 'Rent an item', 'book_date', 'item', 'day', 'duration', 'unit', 'inventory', 1, 0, 0, 1, 1, 0, 0, NULL, '2021-03-12 00:56:53', '2021-03-12 00:56:53', 0),
(6, 'Request', 'Request', 'request', NULL, NULL, 'unit', 'unit', 'quantity', 1, 0, 0, 1, 0, 0, 0, '{"per_label_buyer":null,"quantity_label_buyer":null,"can_seller_enter_per_label":false}', '2021-03-12 00:56:53', '2021-05-19 16:33:45', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reported_listings`
--

CREATE TABLE IF NOT EXISTS `reported_listings` (
  `id` int unsigned NOT NULL,
  `listing_id` int NOT NULL,
  `user_id` int NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `moderator_id` int DEFAULT NULL,
  `moderator_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'member', 'web', '2021-03-12 00:56:52', '2021-03-12 00:56:52'),
(2, 'editor', 'web', '2021-03-12 00:56:53', '2021-03-12 00:56:53'),
(3, 'moderator', 'web', '2021-03-12 00:56:53', '2021-03-12 00:56:53'),
(4, 'admin', 'web', '2021-03-12 00:56:53', '2021-03-12 00:56:53'),
(5, 'mediator', 'web', '2021-08-22 13:00:51', '2021-08-22 13:00:51');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE IF NOT EXISTS `role_has_permissions` (
  `permission_id` int unsigned NOT NULL,
  `role_id` int unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 2),
(2, 2),
(3, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 3),
(1, 4),
(2, 4),
(3, 4),
(4, 4),
(5, 4),
(6, 5);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int unsigned NOT NULL,
  `key` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`) VALUES
(3, 'site_name', 'PlaCard'),
(5, 'theme', 'default'),
(6, 'currency', 'USD'),
(7, 'name', 'Request'),
(8, 'widget', 'buy'),
(9, 'unit_name', 'property'),
(10, 'duration_name', ''),
(11, 'can_add_pricing', '1'),
(13, 'default_pricing_model', '4'),
(14, 'home_title', 'Home'),
(15, 'home_description', ''),
(16, 'site_title', 'PlaCard'),
(19, 'show_map', '0'),
(20, 'show_list', '1'),
(21, 'show_grid', '1'),
(22, 'default_view', 'grid'),
(29, 'distance_unit', 'km'),
(30, 'default_locale', 'US'),
(31, 'supported_locales.0', 'RU'),
(35, 'listings_require_verification', '0'),
(36, 'site_url', '/'),
(37, 'enable_geo_search', '0'),
(38, 'marketplace_transaction_fee', '0'),
(39, 'marketplace_percentage_fee', '0'),
(41, 'paypal_email', ''),
(42, 'paypal_username', ''),
(43, 'paypal_password', ''),
(44, 'paypal_signature', ''),
(45, 'paypal_mode', 'sandbox'),
(64, 'custom_homepage', '0'),
(65, 'show_search_sidebar', '1'),
(67, 'moderatelistings.report_types.0.value', 'Inappropriate'),
(68, 'moderatelistings.report_types.1.value', 'Duplicate'),
(69, 'moderatelistings.report_types.2.value', 'Spam'),
(70, 'supported_locales.1', 'UA'),
(71, 'marketplace_index', 'home'),
(72, 'googlmapper.key', ''),
(87, 'single_listing_per_user', '0'),
(102, 'payments_enabled', '1'),
(103, 'supported_locales.2', 'BY'),
(113, 'supported_locales.3', 'KZ'),
(114, 'supported_locales.4', 'DE'),
(115, 'supported_locales.5', 'ABKHAZIA'),
(116, 'supported_locales.6', 'AU'),
(117, 'supported_locales.7', 'AT'),
(118, 'supported_locales.8', 'AZ'),
(119, 'supported_locales.9', 'AL'),
(120, 'supported_locales.10', 'DZ'),
(121, 'supported_locales.11', 'AO'),
(122, 'supported_locales.12', 'AI'),
(123, 'supported_locales.13', 'AD'),
(124, 'supported_locales.14', 'AG'),
(125, 'supported_locales.15', 'AN'),
(126, 'supported_locales.16', 'AR'),
(127, 'supported_locales.17', 'AM'),
(128, 'supported_locales.18', 'AW'),
(129, 'supported_locales.19', 'AF'),
(130, 'supported_locales.20', 'BS'),
(131, 'supported_locales.21', 'BD'),
(132, 'supported_locales.22', 'BB'),
(133, 'supported_locales.23', 'BH'),
(134, 'supported_locales.24', 'BZ'),
(135, 'supported_locales.25', 'BE'),
(136, 'supported_locales.26', 'BJ'),
(137, 'supported_locales.27', 'BM'),
(138, 'supported_locales.28', 'BG'),
(139, 'supported_locales.29', 'BO'),
(140, 'supported_locales.30', 'BA'),
(141, 'supported_locales.31', 'BW'),
(142, 'supported_locales.32', 'BR'),
(143, 'supported_locales.33', 'VG'),
(144, 'supported_locales.34', 'BN'),
(145, 'supported_locales.35', 'BF'),
(146, 'supported_locales.36', 'BI'),
(147, 'supported_locales.37', 'BT'),
(148, 'supported_locales.38', 'WF'),
(149, 'supported_locales.39', 'VU'),
(150, 'supported_locales.40', 'GB'),
(151, 'supported_locales.41', 'HU'),
(152, 'supported_locales.42', 'VE'),
(153, 'supported_locales.43', 'TL'),
(154, 'supported_locales.44', 'VN'),
(155, 'supported_locales.45', 'GA'),
(156, 'supported_locales.46', 'HT'),
(157, 'supported_locales.47', 'GY'),
(158, 'supported_locales.48', 'GM'),
(159, 'supported_locales.49', 'GH'),
(160, 'supported_locales.50', 'GP'),
(161, 'supported_locales.51', 'GT'),
(162, 'supported_locales.52', 'GN'),
(163, 'supported_locales.53', 'GW'),
(164, 'supported_locales.54', 'GG'),
(165, 'supported_locales.55', 'GI'),
(166, 'supported_locales.56', 'HN'),
(167, 'supported_locales.57', 'HK'),
(168, 'supported_locales.58', 'GD'),
(169, 'supported_locales.59', 'GL'),
(170, 'supported_locales.60', 'GR'),
(171, 'supported_locales.61', 'GE'),
(172, 'supported_locales.62', 'DK'),
(173, 'supported_locales.63', 'JE'),
(174, 'supported_locales.64', 'DJ'),
(175, 'supported_locales.65', 'DO'),
(176, 'supported_locales.66', 'EG'),
(177, 'supported_locales.67', 'ZM'),
(178, 'supported_locales.68', 'EH'),
(179, 'supported_locales.69', 'ZW'),
(180, 'supported_locales.70', 'IL'),
(181, 'supported_locales.71', 'IN'),
(182, 'supported_locales.72', 'ID'),
(183, 'supported_locales.73', 'JO'),
(184, 'supported_locales.74', 'IQ'),
(185, 'supported_locales.75', 'IR'),
(186, 'supported_locales.76', 'IE'),
(187, 'supported_locales.77', 'IS'),
(188, 'supported_locales.78', 'ES'),
(189, 'supported_locales.79', 'IT'),
(190, 'supported_locales.80', 'YE'),
(191, 'supported_locales.81', 'CV'),
(192, 'supported_locales.82', 'KH'),
(193, 'supported_locales.83', 'CM'),
(194, 'supported_locales.84', 'CA'),
(195, 'supported_locales.85', 'QA'),
(196, 'supported_locales.86', 'KE'),
(197, 'supported_locales.87', 'CY'),
(198, 'supported_locales.88', 'KI'),
(199, 'supported_locales.89', 'CN'),
(200, 'supported_locales.90', 'CO'),
(201, 'supported_locales.91', 'KM'),
(202, 'supported_locales.92', 'CD'),
(203, 'supported_locales.93', 'CR'),
(204, 'supported_locales.94', 'CI'),
(205, 'supported_locales.95', 'CU'),
(206, 'supported_locales.96', 'KW'),
(207, 'supported_locales.97', 'CK'),
(208, 'supported_locales.98', 'KG'),
(209, 'supported_locales.99', 'LA'),
(210, 'supported_locales.100', 'LV'),
(211, 'supported_locales.101', 'LS'),
(212, 'supported_locales.102', 'LR'),
(213, 'supported_locales.103', 'LB'),
(214, 'supported_locales.104', 'LY'),
(215, 'supported_locales.105', 'LT'),
(216, 'supported_locales.106', 'LI'),
(217, 'supported_locales.107', 'LU'),
(218, 'supported_locales.108', 'MU'),
(219, 'supported_locales.109', 'MR'),
(220, 'supported_locales.110', 'MG'),
(221, 'supported_locales.111', 'MK'),
(222, 'supported_locales.112', 'MW'),
(223, 'supported_locales.113', 'MY'),
(224, 'supported_locales.114', 'ML'),
(225, 'supported_locales.115', 'MV'),
(226, 'supported_locales.116', 'MT'),
(227, 'supported_locales.117', 'MQ'),
(228, 'supported_locales.118', 'MX'),
(229, 'supported_locales.119', 'MZ'),
(230, 'supported_locales.120', 'MD'),
(231, 'supported_locales.121', 'MC'),
(232, 'supported_locales.122', 'MN'),
(233, 'supported_locales.123', 'MA'),
(234, 'supported_locales.124', 'MM'),
(235, 'supported_locales.125', 'IM'),
(236, 'supported_locales.126', 'NA'),
(237, 'supported_locales.127', 'NR'),
(238, 'supported_locales.128', 'NP'),
(239, 'supported_locales.129', 'NE'),
(240, 'supported_locales.130', 'NG'),
(241, 'supported_locales.131', 'NL'),
(242, 'supported_locales.132', 'NI'),
(243, 'supported_locales.133', 'NZ'),
(244, 'supported_locales.134', 'NC'),
(245, 'supported_locales.135', 'NO'),
(246, 'supported_locales.136', 'NF'),
(247, 'supported_locales.137', 'AE'),
(248, 'supported_locales.138', 'OM'),
(249, 'supported_locales.139', 'PK'),
(250, 'supported_locales.140', 'PA'),
(251, 'supported_locales.141', 'PG'),
(252, 'supported_locales.142', 'PY'),
(253, 'supported_locales.143', 'PE'),
(254, 'supported_locales.144', 'PN'),
(255, 'supported_locales.145', 'PL'),
(256, 'supported_locales.146', 'PT'),
(257, 'supported_locales.147', 'PR'),
(258, 'supported_locales.148', 'RE'),
(259, 'supported_locales.149', 'RW'),
(260, 'supported_locales.150', 'RO'),
(261, 'supported_locales.151', 'US'),
(262, 'supported_locales.152', 'SV'),
(263, 'supported_locales.153', 'WS'),
(264, 'supported_locales.154', 'SM'),
(265, 'supported_locales.155', 'ST'),
(266, 'supported_locales.156', 'SA'),
(267, 'supported_locales.157', 'SZ'),
(268, 'supported_locales.158', 'LC'),
(269, 'supported_locales.159', 'SH'),
(270, 'supported_locales.160', 'KP'),
(271, 'supported_locales.161', 'SC'),
(272, 'supported_locales.162', 'PM'),
(273, 'supported_locales.163', 'SN'),
(274, 'supported_locales.164', 'KN'),
(275, 'supported_locales.165', 'VC'),
(276, 'supported_locales.166', 'RS'),
(277, 'supported_locales.167', 'SG'),
(278, 'supported_locales.168', 'SY'),
(279, 'supported_locales.169', 'SK'),
(280, 'supported_locales.170', 'SI'),
(281, 'supported_locales.171', 'SB'),
(282, 'supported_locales.172', 'SO'),
(283, 'supported_locales.173', 'SD'),
(284, 'supported_locales.174', 'SR'),
(285, 'supported_locales.175', 'SL'),
(286, 'supported_locales.176', 'TJ'),
(287, 'supported_locales.177', 'TW'),
(288, 'supported_locales.178', 'TH'),
(289, 'supported_locales.179', 'TZ'),
(290, 'supported_locales.180', 'TG'),
(291, 'supported_locales.181', 'TK'),
(292, 'supported_locales.182', 'TO'),
(293, 'supported_locales.183', 'TT'),
(294, 'supported_locales.184', 'TV'),
(295, 'supported_locales.185', 'TN'),
(296, 'supported_locales.186', 'TM'),
(297, 'supported_locales.187', 'TC'),
(298, 'supported_locales.188', 'TR'),
(299, 'supported_locales.189', 'UG'),
(300, 'supported_locales.190', 'UZ'),
(301, 'supported_locales.191', 'UY'),
(302, 'supported_locales.192', 'FO'),
(303, 'supported_locales.193', 'FJ'),
(304, 'supported_locales.194', 'PH'),
(305, 'supported_locales.195', 'FI'),
(306, 'supported_locales.196', 'FR'),
(307, 'supported_locales.197', 'GF'),
(308, 'supported_locales.198', 'PF'),
(309, 'supported_locales.199', 'HR'),
(310, 'supported_locales.200', 'TD'),
(311, 'supported_locales.201', 'ME'),
(312, 'supported_locales.202', 'CZ'),
(313, 'supported_locales.203', 'CL'),
(314, 'supported_locales.204', 'CH'),
(315, 'supported_locales.205', 'SE'),
(316, 'supported_locales.206', 'LK'),
(317, 'supported_locales.207', 'EC'),
(318, 'supported_locales.208', 'GQ'),
(319, 'supported_locales.209', 'ER'),
(320, 'supported_locales.210', 'EE'),
(321, 'supported_locales.211', 'ET'),
(322, 'supported_locales.212', 'ZA'),
(323, 'supported_locales.213', 'KR'),
(324, 'supported_locales.214', 'SOUTH-'),
(325, 'supported_locales.215', 'JM'),
(326, 'supported_locales.216', 'JP'),
(327, 'supported_locales.217', 'MO'),
(357, 'site_logo', 'logo.png'),
(371, 'logo', 'http://placard.zr-code.com/storage/images/logo.png'),
(381, 'bitmessage_ip', '95.217.251.153:8884'),
(382, 'bitmessage_client_username', 'api'),
(383, 'bitmessage_client_password', 'ZeoMfFmhHPji_-KB4NWcvA=='),
(384, 'electrum_ip', '95.217.251.153:7778'),
(385, 'electrum_client_username', 'user'),
(386, 'electrum_client_password', 'yXQBZZrMF7VspZvBLueZcw=='),
(396, 'bitdeals_username', 'n2f3cbeUUFhbz6mFLpDUzMnrt72sPu7WQK'),
(397, 'bitdeals_password', '7Q3xZ1INi2JJdvXlmE85');

-- --------------------------------------------------------

--
-- Table structure for table `taggables`
--

CREATE TABLE IF NOT EXISTS `taggables` (
  `tag_id` int unsigned NOT NULL,
  `taggable_id` int unsigned NOT NULL,
  `taggable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `taggables`
--

INSERT INTO `taggables` (`tag_id`, `taggable_id`, `taggable_type`) VALUES
(3, 1, 'App\\Models\\Listing'),
(4, 1, 'App\\Models\\Listing'),
(3, 6, 'App\\Models\\Listing'),
(4, 6, 'App\\Models\\Listing'),
(7, 24, 'App\\Models\\Listing'),
(8, 24, 'App\\Models\\Listing'),
(9, 27, 'App\\Models\\Listing'),
(10, 28, 'App\\Models\\Listing'),
(11, 29, 'App\\Models\\Listing'),
(3, 31, 'App\\Models\\Listing'),
(4, 31, 'App\\Models\\Listing'),
(12, 33, 'App\\Models\\Listing'),
(13, 33, 'App\\Models\\Listing'),
(14, 33, 'App\\Models\\Listing'),
(15, 33, 'App\\Models\\Listing'),
(16, 33, 'App\\Models\\Listing'),
(17, 33, 'App\\Models\\Listing'),
(18, 33, 'App\\Models\\Listing'),
(12, 34, 'App\\Models\\Listing'),
(13, 34, 'App\\Models\\Listing'),
(14, 34, 'App\\Models\\Listing'),
(15, 34, 'App\\Models\\Listing'),
(16, 34, 'App\\Models\\Listing'),
(17, 34, 'App\\Models\\Listing'),
(18, 34, 'App\\Models\\Listing'),
(19, 32, 'App\\Models\\Listing'),
(20, 32, 'App\\Models\\Listing'),
(21, 32, 'App\\Models\\Listing'),
(22, 32, 'App\\Models\\Listing'),
(23, 32, 'App\\Models\\Listing'),
(24, 32, 'App\\Models\\Listing'),
(25, 32, 'App\\Models\\Listing');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int unsigned NOT NULL,
  `name` json NOT NULL,
  `slug` json NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_column` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`, `slug`, `type`, `order_column`, `created_at`, `updated_at`) VALUES
(1, '{"US": "new"}', '{"US": "new"}', NULL, 1, '2021-09-03 08:00:27', '2021-09-03 08:00:27'),
(2, '{"US": "tag"}', '{"US": "tag"}', NULL, 2, '2021-09-03 08:00:27', '2021-09-03 08:00:27'),
(3, '{"US": "hello"}', '{"US": "hello"}', NULL, 3, '2021-09-06 08:45:25', '2021-09-06 08:45:25'),
(4, '{"US": "world"}', '{"US": "world"}', NULL, 4, '2021-09-06 08:45:25', '2021-09-06 08:45:25'),
(5, '{"UA": "hello"}', '{"UA": "hello"}', NULL, 5, '2021-10-21 13:08:45', '2021-10-21 13:08:45'),
(6, '{"UA": "world"}', '{"UA": "world"}', NULL, 6, '2021-10-21 13:08:45', '2021-10-21 13:08:45'),
(7, '{"US": "apple"}', '{"US": "apple"}', NULL, 7, '2021-12-29 08:13:50', '2021-12-29 08:13:50'),
(8, '{"US": "fruit"}', '{"US": "fruit"}', NULL, 8, '2021-12-29 08:13:50', '2021-12-29 08:13:50'),
(9, '{"US": "orange"}', '{"US": "orange"}', NULL, 9, '2022-01-05 08:50:54', '2022-01-05 08:50:54'),
(10, '{"US": "cakes"}', '{"US": "cakes"}', NULL, 10, '2022-01-06 09:27:44', '2022-01-06 09:27:44'),
(11, '{"US": "brown"}', '{"US": "brown"}', NULL, 11, '2022-01-18 08:25:30', '2022-01-18 08:25:30'),
(12, '{"US": "one"}', '{"US": "one"}', NULL, 12, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(13, '{"US": "two"}', '{"US": "two"}', NULL, 13, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(14, '{"US": "three"}', '{"US": "three"}', NULL, 14, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(15, '{"US": "four"}', '{"US": "four"}', NULL, 15, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(16, '{"US": "five"}', '{"US": "five"}', NULL, 16, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(17, '{"US": "six"}', '{"US": "six"}', NULL, 17, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(18, '{"US": "seven"}', '{"US": "seven"}', NULL, 18, '2022-02-25 11:51:58', '2022-02-25 11:51:58'),
(19, '{"JP": "one"}', '{"JP": "one"}', NULL, 19, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(20, '{"JP": "two"}', '{"JP": "two"}', NULL, 20, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(21, '{"JP": "three"}', '{"JP": "three"}', NULL, 21, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(22, '{"JP": "four"}', '{"JP": "four"}', NULL, 22, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(23, '{"JP": "five"}', '{"JP": "five"}', NULL, 23, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(24, '{"JP": "six"}', '{"JP": "six"}', NULL, 24, '2022-02-26 11:43:18', '2022-02-26 11:43:18'),
(25, '{"JP": "seven"}', '{"JP": "seven"}', NULL, 25, '2022-02-26 11:43:18', '2022-02-26 11:43:18');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int unsigned NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trader_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'individual',
  `business_vat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'en',
  `unread_messages` int DEFAULT '0',
  `is_admin` tinyint(1) DEFAULT '0',
  `ip_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` point DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blocked_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `filters` json DEFAULT NULL,
  `can_accept_payments` tinyint(1) DEFAULT '0',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banned_at` datetime DEFAULT NULL,
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `identity_verification_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'NOT_SUBMITTED',
  `identity_verification_changed_at` datetime DEFAULT NULL,
  `bitcoin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bitmessage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `display_name`, `username`, `slug`, `bio`, `phone`, `email`, `trader_type`, `business_vat_id`, `avatar`, `password`, `remember_token`, `gender`, `city`, `region`, `country`, `country_name`, `locale`, `unread_messages`, `is_admin`, `ip_address`, `location`, `last_login_at`, `last_login_ip`, `blocked_at`, `created_at`, `updated_at`, `deleted_at`, `filters`, `can_accept_payments`, `verified`, `verification_token`, `banned_at`, `provider`, `provider_id`, `identity_verification_status`, `identity_verification_changed_at`, `bitcoin`, `bitmessage`, `currency`) VALUES
(1, 'Admin', 'admin', 'admin', 'admin', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '123456789', '1647257398@localhost.loc', 'individual', NULL, NULL, '$2y$10$uIM.X7/fMohWRVJpGlt8rewBiqtzuvklZ/oi9.wapaZ9cn5TwbD7G', 'Xu0iq6FPJWaZsAPSb3x4vMsxW7nD7ExtHNebQK4lcc4eZFl9ZQwfehm1ONs0', 'M', 'Lviv', 'Lviv Oblast', 'UA', 'Ukraine', 'US', 5, 1, NULL, NULL, '2022-03-21 11:18:06', '185.42.129.137', NULL, '2021-03-12 00:56:52', '2022-03-21 09:18:06', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, '1K1xFT3gQenwYiA3xf6rwYppkiFYPViqEh', 'BM-GuE6Z6iKBGYDP6FS86j5REMdoQeXAHmA', 'RUB'),
(2, 'test 2', 'test 2', 'test 2', 'test-2', NULL, NULL, 'test@test.com', 'individual', NULL, NULL, '$2y$10$VEWHTmdvN8K2Cm/CDEvD9OLHXO1.d4GR49s5Fq2OwrYsfquXPyMAm', NULL, NULL, 'Shinjuku', 'Tokyo', 'JP', 'Japan', 'US', 0, 0, NULL, NULL, '2021-06-14 14:04:41', '127.0.0.1', NULL, '2021-06-14 11:04:41', '2021-06-14 11:28:26', NULL, NULL, 0, 1, 'cc3161d76d6c9babad2bac98cf09ea3149d20c0247c0188cce9869036e0489ab', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, '1K1xFT3gQenwYiA3xf6rwYppkiFYPViqEf', '', ''),
(3, 'Mediator', 'Mediator', 'Mediator', 'mediator', NULL, NULL, 'mediator@test.com', 'individual', NULL, NULL, '$2y$10$GBrmNS7.ZLDZkRx6647iieOj6ZnUPm/XLsX9G61d87a1R8CAlIsOO', NULL, NULL, 'Kharkiv', 'Kharkivska Oblast', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2021-12-13 15:55:40', '178.137.54.187', NULL, '2021-08-22 13:20:43', '2021-12-13 13:56:16', NULL, NULL, 0, 1, 'c55902c52ad7844ac82769197f260f2eef38d87c1ae7625239659c31d069e8a4', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'n4hyLS9HReQwmr9Dia4ixqHrtq4ZwmMTX9', '', ''),
(4, 'TestBM', NULL, 'TestBM', 'testbm', NULL, NULL, 'TestBM@test.com', 'individual', NULL, NULL, '$2y$10$sP6rUKcXjMXkpBFItG0NR.78LTzmPHygvitMy1.yK8Xr2AXGUUwCq', '16HGc4ConXplWXNi7JJInxHYwjyrlfcCUVxB0Hv4odqZlWMPdJIln2FuFNBD', NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2021-11-23 17:22:54', '95.69.241.175', NULL, '2021-11-23 11:49:48', '2021-11-23 15:22:54', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, '1NPARGjWJSdV5hiWyBTzvq5gj2jMFLCqsZ', 'BM-GuPe9L2sHJkjcN3oxTRGUNis91bvEzg8', 'USD'),
(5, 'Tester', NULL, 'Tester', 'tester', NULL, NULL, 'test@example.org', 'individual', NULL, NULL, '$2y$10$JgVM3Ktn4mG32n5lBSkod.C5vWRNa4VcDV5pATjpm7qsqSXb5/r9C', 'SCtY06AXfqauaw2lMkXzR6LC8uD9H6kxLYmqxndVyRbROwZKY1k3MF5MVRvN', NULL, 'London', 'England', 'GB', 'United Kingdom', 'US', 0, 0, NULL, NULL, '2021-12-16 09:45:17', '193.32.210.123', NULL, '2021-12-14 07:59:04', '2021-12-20 07:50:54', '2021-12-20 07:50:54', NULL, 0, 0, '66c7cccd5908b48707d5e6593bf44da3f356746af6749e415e41f1c398772ff5', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mhF1jF2M5CE29snSdDundSDJSHeQVgd1XC', 'BM-NBKjhRpsciJbLMGMRebC3VSefHvir6LE', 'USD'),
(6, 'test2', 'test2', 'test2', 'test2', NULL, NULL, 'test2@mail.org', 'individual', NULL, NULL, NULL, 'faklg28fWIstyT4EHlwpTE9L5FIE8H3ToiK6j35GG3N23yDM9VVu4Y7H8B26', NULL, 'City of London', 'England', 'GB', 'United Kingdom', 'US', 3, 0, NULL, NULL, '2021-12-16 10:17:35', '217.146.90.173', NULL, '2021-12-16 08:17:35', '2021-12-20 07:52:05', '2021-12-20 07:52:05', NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mts5fg4uEYH75Nf43W6BCKJZnS5iFwsby1', 'BM-NBo8NxKtZuJBARFoBvYJQTYXQRLKAcct', 'USD'),
(7, 'Testlog', NULL, 'Testlog', 'testlog', NULL, NULL, 'Testlog1639748911@localhost', 'individual', NULL, NULL, '$2y$10$Xqa.CzIIhhQvcKTaiPPRzOEKiIsaXigRXu0TcnjdDu04VF9zUdxW6', NULL, NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2021-12-17 13:48:31', '95.69.241.175', NULL, '2021-12-17 11:48:31', '2021-12-17 11:48:31', NULL, NULL, 0, 0, '34e71a4c17c7d8916269f84a2061f5981f8e2bb8340455491d9a714aff7018a8', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, '1221221122121212121212121211221212121', 'bm-TestlogTestlogTestlogTestlogTestlog', 'USD'),
(8, 'u1', NULL, 'u1', 'u1', NULL, NULL, 'u11639997436@localhost', 'individual', NULL, NULL, '$2y$10$6DHNmfVeNci2ofN8U5PLceL8Gsga3o3tGDy8E9RGHt3rxi9EfBNBK', NULL, NULL, 'Kuala Lumpur', 'Kuala Lumpur', 'MY', 'Malaysia', 'US', 2, 0, NULL, NULL, '2021-12-20 10:50:36', '103.212.70.224', NULL, '2021-12-20 08:50:36', '2021-12-20 09:30:33', NULL, NULL, 0, 0, 'd5a1f1a83d6e8084c4718249dbe0ce8c74fbe943ff4a74c431d2d76902069b88', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mqkH84NjpN4dweCfrWWQFrDN2HwFk9uPmc', 'u11639997435@localhost', 'USD'),
(9, 'u2', NULL, 'u2', 'u2', NULL, NULL, 'u21639997515@localhost', 'individual', NULL, NULL, '$2y$10$02GDwSMCaWWxXy/QNCJzhO/WS7EPPhB9PyiVi6si1uL6HBTXP8fH6', NULL, NULL, 'Kuala Lumpur', 'Kuala Lumpur', 'MY', 'Malaysia', 'US', 0, 0, NULL, NULL, '2021-12-20 10:51:55', '103.212.70.224', NULL, '2021-12-20 08:51:55', '2021-12-20 08:51:55', NULL, NULL, 0, 0, '57e2169097ae980b130f2ab667d6a5b16903dd500d0ff427850aa13b1aa2e979', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mg6YZBEzEBSKG8Xw39Q4DS6t8vXeRjjvDw', 'u21639997514@localhost', 'USD'),
(10, 'u3', NULL, 'u3', 'u3', NULL, NULL, 'u31639997708@localhost', 'individual', NULL, NULL, '$2y$10$84i8CDGnWF.S0HQimDDsLu0TXu3EORisI2qMiDirYgRkM4JaEuKx6', NULL, NULL, 'Kuala Lumpur', 'Kuala Lumpur', 'MY', 'Malaysia', 'US', 0, 0, NULL, NULL, '2021-12-20 10:55:08', '103.212.70.224', NULL, '2021-12-20 08:55:08', '2021-12-20 08:55:08', NULL, NULL, 0, 0, '1a512be3fbf0e7b00942bdb4b9aefd2b81745d78a2322befc484dd31775d9ead', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mvDd19FbDAs9LQ7ka1e1mmC59YgXEBrLVK', 'u31639997708@localhost', 'USD'),
(11, 'test222', NULL, 'test222', 'test222', NULL, NULL, 'test2221640107116@localhost', 'individual', NULL, NULL, '$2y$10$XHPFAr54igaaYs31rCp.5e72scemv5yTzd9KPtyxTle4HuhlTP57q', NULL, NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'UA', 0, 0, NULL, NULL, '2021-12-21 17:18:36', '31.202.127.81', NULL, '2021-12-21 15:18:36', '2021-12-21 15:18:36', NULL, NULL, 0, 0, 'f8a176216291b93261dcdb129cc8fa7f6601c44d867bc2748d354765ce87934a', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'BM-2cVhRu3oCjM7PSrP645o1SdEozK6Whh5zj', 'test2221640107116@localhost', 'USD'),
(12, 'testestsesdasdas', NULL, 'testestsesdasdas', 'testestsesdasdas', NULL, NULL, 'testestsesdasdas1640190803@localhost', 'individual', NULL, NULL, '$2y$10$cN5WWmgWC8P/ZGy/URpQ0OtyaRRDlrBKCcFPLbADagNIpA1eNMqFS', 'IEgj1idcsxPjiHir7Sl11AsT7VsRtqHmQ8POj2yma3iGSpzqKuqtGhpv1A0J', NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2021-12-22 16:33:23', '95.69.241.175', NULL, '2021-12-22 14:33:23', '2021-12-22 14:33:23', NULL, NULL, 0, 0, '79d20f386cc09f334ebba03802a299bfefae4564553922e737605e339fd2d1cb', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'BM-GuAqZJp22GUVaS7ZhecZk1SAKwZTnqBV', 'BM-GuAqZJp22GUVaS7ZhecZk1SAKwZTnqBV', 'USD'),
(13, 'testnewtews', NULL, 'testnewtews', 'testnewtews', NULL, NULL, 'testnewtews1640191547@localhost', 'individual', NULL, NULL, '$2y$10$08I/OXRx7iocdsfwLON/qev8L5yVkKFoV4q/ipROmzWmTxVWxyWnK', NULL, NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2021-12-22 16:45:48', '95.69.241.175', NULL, '2021-12-22 14:45:48', '2021-12-22 14:52:10', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'BM-GuPe9L2sHJkjcN3oxTRGUNis91bvEzg8', 'BM-Gttjwv7ETjfqX2v53z3AuguRjEi9TMFx', 'USD'),
(14, 'u4', NULL, 'u4', 'u4', NULL, NULL, 'u41640257545@localhost', 'individual', NULL, NULL, '$2y$10$L1/KUHRcz093XUKH1VrHturxbYkfx5hSdGm.bVAdaKitBOjzvhgXm', 'B8koLmKTaPtFKON64a4fVWEAlL1Hul39gqABeSjze4KZBM276gglqD1g07jb', NULL, 'Warsaw', 'Mazovia', 'PL', 'Poland', 'US', 0, 0, NULL, NULL, '2021-12-29 09:41:17', '194.99.105.243', NULL, '2021-12-23 09:05:45', '2021-12-29 07:41:17', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mqN5vugsRLQfR8nVN9QNwpw44ovtGjg7hX', 'BM-2cTPB44jSFASaJvzMH3YzCSapaK8Rom7oR', 'USD'),
(15, 'u5', NULL, 'u5', 'u5', NULL, NULL, 'u51640258485@localhost', 'individual', NULL, NULL, '$2y$10$qMFFVsw2JOBhNepn.BztWuC8qEEKt9s/8HT7IPQFWFmWDawl0AUGu', 'wbJjExkC2dsJhHImhn9RnjCkzYyfLmTVYZpY6zOCQDmXWW2TCdGCVQiKOYVk', NULL, 'Warsaw', 'Mazovia', 'PL', 'Poland', 'US', 0, 0, NULL, NULL, '2021-12-29 09:40:18', '194.99.105.243', NULL, '2021-12-23 09:21:26', '2021-12-29 07:40:18', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'msWPKthLBnPPhhs2jEd1hzvtzru4a7QA2n', 'BM-2cUgeFR5GUUz2QobLoMzvwqSTiaR5utj9f', 'USD'),
(16, 'u6', NULL, 'u6', 'u6', NULL, NULL, 'u61640259011@localhost', 'individual', NULL, NULL, '$2y$10$5iBVOAWm9GMBNI.n34x/reVmqzHZWtqO2zVqh7LNYpdwaKLemwGVq', NULL, NULL, 'Vienna', 'Vienna', 'AT', 'Austria', 'US', 0, 0, NULL, NULL, '2021-12-23 11:30:12', '185.236.202.89', NULL, '2021-12-23 09:30:12', '2021-12-23 09:32:51', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'ms6cqLBo13Q7D6JGVA2mKh61iF8xMFsDum', 'BM-2cWRavCXcQwfhmd4iDNmDyv4CCVUM45M2k', 'USD'),
(17, 'u07', NULL, 'u07', 'u07', NULL, NULL, 'u071640771594@localhost', 'individual', NULL, NULL, '$2y$10$Jp0vCbmG5InM1zLWhfLMKO41ptuYaGTh8xVBL37.Tf.wM5TOUhvKa', NULL, NULL, 'Warsaw', 'Mazovia', 'PL', 'Poland', 'US', 0, 0, NULL, NULL, '2021-12-29 09:53:14', '194.99.105.243', NULL, '2021-12-29 07:53:14', '2021-12-29 07:56:49', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'muztGTcYoM56tsGbT8XXhqLxYxAjKcpefw', 'BM-2cV4RitzmHTfFpsJpANt1vHhLTNafBUJNv', 'USD'),
(18, 'u08', NULL, 'u08', 'u08', NULL, NULL, 'u081640771683@localhost', 'individual', NULL, NULL, '$2y$10$dbsgFhMQwqfnzW4ftcOmSeHNsVIcoxYy94yRx0aBCOfveSFJwm/RW', NULL, NULL, 'Warsaw', 'Mazovia', 'PL', 'Poland', 'US', 0, 0, NULL, NULL, '2021-12-29 09:54:43', '194.99.105.243', NULL, '2021-12-29 07:54:43', '2021-12-29 07:57:39', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mrb57DFzKz2xcFYyPiVXaeF71QkeDUFGNS', 'BM-2cSmvkMyqJbXzCWcv2NG28syXzV2uUsxyb', 'USD'),
(19, 'u09', NULL, 'u09', 'u09', NULL, NULL, 'u091640771887@localhost', 'individual', NULL, NULL, '$2y$10$CZwP6z/Lpouxdrx21S2or.wYDmZCynnfkw7rS/OzoFXxHUvPsQsa6', NULL, NULL, 'Warsaw', 'Mazovia', 'PL', 'Poland', 'US', 0, 0, NULL, NULL, '2021-12-29 09:58:07', '194.99.105.243', NULL, '2021-12-29 07:58:07', '2021-12-29 08:10:58', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'muSeAZTZRxkqHGbXPZvWMtAxq1TUyq4Hw1', 'BM-NBLSedHZ13W6dbpCmQ4maCDpgJ9sHcdq', 'USD'),
(20, 'mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw', 'mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw', 'mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw', 'mvmagfm6nhmungvfsjzclr8k6f3dylesvw', NULL, NULL, 'mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw@mail.com', 'individual', NULL, NULL, NULL, 'qXmjc0Boz48Krz7k6wVo68y8AjLR5cekr1iNjlQqeOaBm5OVIEenMWCqHkIq', NULL, 'City of London', 'England', 'GB', 'United Kingdom', 'US', 0, 0, NULL, NULL, '2022-01-06 08:28:58', '81.92.200.125', NULL, '2022-01-04 09:10:30', '2022-01-06 07:47:52', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mvmAgFm6nhmUNGvfsJzCLR8k6f3dYLeSvw', '', 'USD'),
(21, 'mzsh4ADkMvrmhxCkJvqhAcUbSWkcp1VgKa', 'mnumHs9HQMrw2Q1iKLNnx9NzExS7nMLmyp', 'mnumHs9HQMrw2Q1iKLNnx9NzExS7nMLmyp', 'mnumhs9hqmrw2q1iklnnx9nzexs7nmlmyp', NULL, NULL, '1645789657@localhost.loc', 'individual', NULL, NULL, NULL, '801MyMgsYXInQy5fBcZtqo6R9YFkWULmPuaY2DqEzgeZJGFGtVXQ8SxbhBW7', NULL, 'Helsinki', 'Uusimaa', 'FI', 'Finland', 'US', 1, 0, NULL, NULL, '2022-03-17 09:43:27', '194.110.84.64', NULL, '2022-01-04 11:15:31', '2022-03-17 07:51:35', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mnumHs9HQMrw2Q1iKLNnx9NzExS7nMLmyp', 'BM-2cUeyFciQjjR6bv2sa4p832EXJpMgGisvs', 'USD'),
(22, 'mraXx7JrmAmuKypdJ1vseQBXySsdRZE5AC', 'mraXx7JrmAmuKypdJ1vseQBXySsdRZE5AC', 'mraXx7JrmAmuKypdJ1vseQBXySsdRZE5AC', 'mraxx7jrmamukypdj1vseqbxyssdrze5ac', NULL, NULL, '1643016629@localhost.loc', 'individual', NULL, NULL, NULL, 'NiOe1rUf0w4xmPI7Cl2oOTpYpMurVk2si4sJrZUWdaII2quQjfHRUdrTSXFj', NULL, 'Tokyo', 'Tokyo', 'JP', 'Japan', 'CH', 0, 0, NULL, NULL, '2022-02-24 11:59:13', '138.199.21.60', NULL, '2022-01-04 11:26:59', '2022-02-24 09:59:13', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mraXx7JrmAmuKypdJ1vseQBXySsdRZE5AC', 'BM-2cUznVEEFqYsMALkAWpgvgYeoH4hXnH2zp', 'EUR'),
(23, 'test 123', NULL, 'test 123', 'test-123', NULL, NULL, 'test 1231641308935@localhost.loc', 'individual', NULL, NULL, '$2y$10$shu6rpEGP7ZnNU4sfuu/6uZ5yCM4KQz.kjNhIo66o9OtK8rQvi5Ku', 'GeUcfZnez9N6myBRbYSidn3Ww9wio3ud2XJmlvJkLHWaUjoLg45lyIxcwCo8', NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2022-01-04 15:08:55', '95.69.241.175', NULL, '2022-01-04 13:08:55', '2022-01-04 13:08:55', NULL, NULL, 0, 0, '2833a28680592c17c5193febd85f78270dc735408f4d1bc5ff03aa8b83bc0821', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'BM-2cTLD1KaeRaUMjm5oHytnAU1tM5m5GE2dd', 'BM-2cTLD1KaeRaUMjm5oHytnAU1tM5m5GE2dd', 'USD'),
(24, 'testestsetse', NULL, 'testestsetse', 'testestsetse', NULL, NULL, 'testestsetse1641309197@localhost.loc', 'individual', NULL, NULL, '$2y$10$YV/cUSdqdgPlv.bgKAlq/ez8WTk7bz0qJtVx86UzPL6Ifuwil2.6y', 'hoLjD7PI1obsiqQ0fgpTGGtykZHmtkgjLZJRWhSVjF7FeNLfma2lCsxMbk3P', NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2022-01-05 16:21:44', '95.69.241.175', NULL, '2022-01-04 13:13:18', '2022-01-05 14:21:44', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'BM-GtHA7A42zYCgKCaMFfsxu1tJbsfBjDKQ', 'BM-GtHA7A42zYCgKCaMFfsxu1tJbsfBjDKQ', 'USD'),
(25, 'n2f3cbeUUFhbz6mFLpDUzMnrt72sPu7WQK', 'n2f3cbeUUFhbz6mFLpDUzMnrt72sPu7WQK', 'n2f3cbeUUFhbz6mFLpDUzMnrt72sPu7WQK', 'n2f3cbeuufhbz6mflpduzmnrt72spu7wqk', NULL, NULL, '1645800442@localhost.loc', 'individual', NULL, NULL, NULL, '4cgA1QcYGZE9FPJORryIp7J0ThZf0YbjBP18uwTypKmhrAFb6ITHm13x3IqH', NULL, 'Zurich', 'Zurich', 'CH', 'Switzerland', 'JP', 0, 0, NULL, NULL, '2022-03-16 11:56:41', '212.102.36.141', NULL, '2022-01-06 09:11:46', '2022-03-16 09:56:41', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'n2f3cbeUUFhbz6mFLpDUzMnrt72sPu7WQK', 'BM-2cSxUoJCBAJmL2Y6nn2hCAeMFeuVwnmdX8', 'GBP'),
(26, 'Test', NULL, 'Test', 'test', NULL, NULL, 'info@zr-code.com', 'individual', NULL, NULL, '$2y$10$x75okJAwL9hV/QAxNUmZse8dqeDbGZtngMb4gRyrLgreVmu9emIqi', NULL, NULL, 'Kharkiv', 'Kharkiv', 'UA', 'Ukraine', 'US', 0, 0, NULL, NULL, '2022-02-21 15:56:38', '95.69.241.175', NULL, '2022-02-21 13:56:38', '2022-02-21 14:16:39', NULL, NULL, 1, 0, 'de4d02e55996cfe26bd68781299e430ef44a273491e930b2fb9306e58ecd7bbf', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, '111111111111111111111111111111111', '', 'USD'),
(27, 'z6', NULL, 'z6', 'z6', NULL, NULL, 'z61646045133@localhost.loc', 'individual', NULL, NULL, '$2y$10$xDdTfnjN5V.skAAi/woL7eO/2M1NnzeBSesny85DjwzywhKi4iyW6', NULL, NULL, 'Helsinki', 'Uusimaa', 'FI', 'Finland', 'US', 0, 0, NULL, NULL, '2022-02-28 10:45:38', '194.110.84.52', NULL, '2022-02-28 08:45:38', '2022-02-28 09:24:47', NULL, NULL, 1, 0, 'eb485394b75bfa46010e82d3f52a349ff65fde0ea4f9e25c9c8315ace9ba2f6f', NULL, NULL, NULL, 'NOT_SUBMITTED', NULL, 'mqzezadxPSHhf84syPMMoaYXgfesx4VH28', 'BM-2cX4qq4vcbhcNC6fhaiqCCinafi4ba6LX4', 'ZAR');

-- --------------------------------------------------------

--
-- Table structure for table `users_meta`
--

CREATE TABLE IF NOT EXISTS `users_meta` (
  `id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'null',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users_meta`
--

INSERT INTO `users_meta` (`id`, `user_id`, `type`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 1, 'array', 'billing_address', '{"full_name":"Full Name","address":"Address","city":"City","state":"State","zip":"000000","country":"US"}', '2021-05-02 13:57:09', '2022-02-23 13:45:24'),
(2, 1, 'array', 'shipping_address', '{"full_name":"Full Name","address":"Address","city":"City","state":"State","zip":"000000","country":"US"}', '2021-05-02 13:57:09', '2022-02-23 13:45:24'),
(3, 2, 'array', 'billing_address', '{"full_name":"Test","address":"Test","city":"123","state":"123","zip":"123","country":null}', '2021-06-14 11:06:28', '2021-06-14 11:06:28'),
(4, 2, 'array', 'shipping_address', '{"full_name":"Test","address":"Test","city":"123","state":"123","zip":"123","country":null}', '2021-06-14 11:06:28', '2021-06-14 11:06:28'),
(5, 1, 'array', 'delivery_regions', '["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM","AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC","RU","UA","BY","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE","KZ","AZ","AM","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP","ZM","AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]', '2021-08-31 14:33:37', '2021-09-01 08:22:10'),
(6, 1, 'array', 'delivery_settings', '[{"factor":"0.50","extend_days":"1","countries":["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM"]},{"factor":"1.00","extend_days":"1","countries":["AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC"]},{"factor":"0.20","extend_days":"0","countries":["RU","UA","BY","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE"]},{"factor":"2.00","extend_days":"2","countries":["KZ","AZ","AM","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP"]},{"factor":"0.00","extend_days":"0","countries":["ZM"]},{"factor":"0.00","extend_days":"0","countries":["AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]}]', '2021-09-01 07:45:42', '2021-09-01 08:22:10'),
(7, 5, 'array', 'billing_address', '{"full_name":"Tester","address":null,"city":null,"state":null,"zip":"1020000","country":"US"}', '2021-12-15 08:18:52', '2021-12-15 08:18:52'),
(8, 5, 'array', 'shipping_address', '{"full_name":"Tester","address":null,"city":null,"state":null,"zip":"1020000","country":"US"}', '2021-12-15 08:18:52', '2021-12-15 08:18:52'),
(9, 6, 'string', 'address', 'Home Streed, My house', '2021-12-16 09:09:36', '2021-12-16 09:09:36'),
(10, 6, 'array', 'billing_address', '{"full_name":"James","address":"Home Street, My House","city":"City","state":null,"zip":"1020000","country":"US"}', '2021-12-16 09:32:55', '2021-12-16 09:32:55'),
(11, 6, 'array', 'shipping_address', '{"full_name":"James","address":"Home Street, My House","city":"City","state":null,"zip":"1020000","country":"US"}', '2021-12-16 09:32:55', '2021-12-16 09:32:55'),
(12, 8, 'array', 'billing_address', '{"full_name":"name","address":"address","city":"city","state":"state","zip":"1020000","country":"RU"}', '2021-12-20 09:25:23', '2021-12-20 09:25:23'),
(13, 8, 'array', 'shipping_address', '{"full_name":"name","address":"address","city":"city","state":"state","zip":"1020000","country":"RU"}', '2021-12-20 09:25:23', '2021-12-20 09:25:23'),
(14, 15, 'array', 'billing_address', '{"full_name":"u5","address":"u5-Home","city":"u5-City","state":"u5-State","zip":"1020000","country":"BS"}', '2021-12-23 09:36:29', '2021-12-23 09:36:29'),
(15, 15, 'array', 'shipping_address', '{"full_name":"u5","address":"u5-Home","city":"u5-City","state":"u5-State","zip":"1020000","country":"BS"}', '2021-12-23 09:36:29', '2021-12-23 09:36:29'),
(16, 18, 'array', 'billing_address', '{"full_name":"u08","address":"MyAddress","city":"MyCity","state":"MyState","zip":"1020000","country":"US"}', '2021-12-29 09:04:45', '2021-12-29 09:04:45'),
(17, 18, 'array', 'shipping_address', '{"full_name":"u08","address":"MyAddress","city":"MyCity","state":"MyState","zip":"1020000","country":"US"}', '2021-12-29 09:04:45', '2021-12-29 09:04:45'),
(18, 1, 'string', 'address', 'Moscow', '2022-01-04 10:20:47', '2022-01-04 10:20:47'),
(19, 22, 'string', 'address', 'MyHomeAddress', '2022-01-04 11:31:12', '2022-01-04 11:31:12'),
(20, 20, 'array', 'delivery_regions', '["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM","AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC","RU","UA","BY","DE","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE","KZ","AZ","AM","AF","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP","DZ","AO","BJ","BW","BF","BI","GA","GM","GH","GN","GW","DJ","EG","ZM","ZW","CM","KE","KM","LS","LR","LY","MU","MR","MG","MW","ML","MZ","MA","NA","NE","NG","RW","ST","SC","SN","SO","SD","SL","TZ","TG","TN","UG","TD","GQ","ER","ET","ZA","AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]', '2022-01-05 08:34:44', '2022-01-05 08:34:44'),
(21, 20, 'array', 'delivery_settings', '[{"factor":"0.00","extend_days":"0","countries":["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM"]},{"factor":"0.00","extend_days":"0","countries":["AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC"]},{"factor":"0.00","extend_days":"0","countries":["RU","UA","BY","DE","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE"]},{"factor":"0.00","extend_days":"0","countries":["KZ","AZ","AM","AF","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP"]},{"factor":"0.00","extend_days":"0","countries":["DZ","AO","BJ","BW","BF","BI","GA","GM","GH","GN","GW","DJ","EG","ZM","ZW","CM","KE","KM","LS","LR","LY","MU","MR","MG","MW","ML","MZ","MA","NA","NE","NG","RW","ST","SC","SN","SO","SD","SL","TZ","TG","TN","UG","TD","GQ","ER","ET","ZA"]},{"factor":"0.00","extend_days":"0","countries":["AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]}]', '2022-01-05 08:34:44', '2022-01-05 08:34:44'),
(22, 25, 'array', 'delivery_regions', '["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM","AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC","RU","UA","BY","DE","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE","KZ","AZ","AM","AF","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP","DZ","AO","BJ","BW","BF","BI","GA","GM","GH","GN","GW","DJ","EG","ZM","ZW","CM","KE","KM","LS","LR","LY","MU","MR","MG","MW","ML","MZ","MA","NA","NE","NG","RW","ST","SC","SN","SO","SD","SL","TZ","TG","TN","UG","TD","GQ","ER","ET","ZA","AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]', '2022-01-18 08:11:50', '2022-01-18 08:11:50'),
(23, 25, 'array', 'delivery_settings', '[{"factor":"2","extend_days":"10","countries":["AG","BS","BB","BZ","HT","GT","HN","GD","DO","CA","CR","CU","MX","NI","PA","US","SV","LC","KN","VC","TT","JM"]},{"factor":"0.00","extend_days":"0","countries":["AR","BO","BR","VE","GY","CO","PY","PE","SR","UY","CL","EC"]},{"factor":"0.00","extend_days":"0","countries":["RU","UA","BY","DE","AT","AL","AD","AM","BE","BG","BA","GB","HU","GR","DK","IE","IS","ES","IT","CY","LV","LT","LI","LU","MT","MD","MC","NL","NO","PL","PT","RO","SM","RS","SK","SI","TR","FI","FR","HR","ME","CH","SE","EE"]},{"factor":"0.00","extend_days":"0","countries":["KZ","AZ","AM","AF","BD","BH","BN","BT","VN","GE","IL","IN","ID","JO","IQ","IR","YE","KH","QA","CY","CN","KW","KG","LA","LB","MY","MV","MN","NP","AE","OM","PK","SA","KP","SG","SY","TJ","TW","TH","TM","UZ","PH","LK","KR","JP"]},{"factor":"0.00","extend_days":"0","countries":["DZ","AO","BJ","BW","BF","BI","GA","GM","GH","GN","GW","DJ","EG","ZM","ZW","CM","KE","KM","LS","LR","LY","MU","MR","MG","MW","ML","MZ","MA","NA","NE","NG","RW","ST","SC","SN","SO","SD","SL","TZ","TG","TN","UG","TD","GQ","ER","ET","ZA"]},{"factor":"0.00","extend_days":"0","countries":["AU","VU","KI","NR","NZ","PG","WS","SB","TO","TV","FJ"]}]', '2022-01-18 08:11:50', '2022-01-18 08:11:50'),
(24, 21, 'string', 'address', 'my home address', '2022-01-18 09:35:39', '2022-01-18 09:35:39'),
(25, 21, 'array', 'billing_address', '{"full_name":"Full Name","address":"Address","city":"City","state":"State","zip":"1020000","country":"US"}', '2022-01-18 10:11:51', '2022-01-18 10:11:51'),
(26, 21, 'array', 'shipping_address', '{"full_name":"Full Name","address":"Address","city":"City","state":"State","zip":"1020000","country":"US"}', '2022-01-18 10:11:51', '2022-01-18 10:11:51');

-- --------------------------------------------------------

--
-- Table structure for table `user_filters`
--

CREATE TABLE IF NOT EXISTS `user_filters` (
  `id` int unsigned NOT NULL,
  `position` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `search_ui` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_input_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_input_meta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_searchable` tinyint(1) DEFAULT '0',
  `is_hidden` tinyint(1) DEFAULT '0',
  `is_default` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE IF NOT EXISTS `wallets` (
  `id` int unsigned NOT NULL,
  `user_id` int unsigned DEFAULT NULL,
  `balance` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wallet_transactions`
--

CREATE TABLE IF NOT EXISTS `wallet_transactions` (
  `id` int unsigned NOT NULL,
  `wallet_id` int unsigned NOT NULL,
  `amount` int NOT NULL,
  `hash` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `widgets`
--

CREATE TABLE IF NOT EXISTS `widgets` (
  `id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alignment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT NULL,
  `style` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `widgets`
--

INSERT INTO `widgets` (`id`, `title`, `alignment`, `type`, `locale`, `metadata`, `background`, `position`, `style`, `created_at`, `updated_at`) VALUES
(6, 'Featured categories', NULL, 'image_gallery', NULL, '[{"title":"Browse","image":"http:\\/\\/s052d7ee0.fastvps-server.com\\/files\\/cmselementpicture\\/74\\/f1\\/a4\\/32770798667_m.jpg","link":"\\/browse","columns":"1"},{"title":"General","image":"http:\\/\\/s052d7ee0.fastvps-server.com\\/files\\/cmselementpicture\\/71\\/cb\\/2d\\/42012368589_m.jpg","link":"\\/browse?category=1","columns":"2"},{"title":"Test","image":"http:\\/\\/s052d7ee0.fastvps-server.com\\/files\\/cmselementpicture\\/bf\\/19\\/45\\/5427709836_m.jpg","link":"\\/browse?category=2","columns":"5"},{"title":"General","image":"http:\\/\\/s052d7ee0.fastvps-server.com\\/files\\/cmselementpicture\\/04\\/22\\/ae\\/62867492943_m.jpg","link":"\\/browse?category=1&view=list","columns":"3"},{"title":"Test","image":"http:\\/\\/s052d7ee0.fastvps-server.com\\/files\\/cmselementpicture\\/99\\/75\\/c6\\/73295044366_m.jpg","link":"\\/browse?category=2&view=list","columns":"4"}]', NULL, 0, NULL, '2021-03-12 00:56:53', '2021-08-26 08:18:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bans_bannable_type_bannable_id_index` (`bannable_type`,`bannable_id`),
  ADD KEY `bans_created_by_type_created_by_id_index` (`created_by_type`,`created_by_id`),
  ADD KEY `bans_expired_at_index` (`expired_at`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `checkout_sessions`
--
ALTER TABLE `checkout_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_commentable_id_commentable_type_index` (`listing_id`),
  ADD KEY `comments_commented_id_commented_type_index` (`commenter_id`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`countryid`),
  ADD KEY `continentid` (`continentid`);

--
-- Indexes for table `custom_files`
--
ALTER TABLE `custom_files`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`user_id`,`favoriteable_id`,`favoriteable_type`),
  ADD KEY `favorites_favoriteable_id_favoriteable_type_index` (`favoriteable_id`,`favoriteable_type`),
  ADD KEY `favorites_user_id_index` (`user_id`);

--
-- Indexes for table `filters`
--
ALTER TABLE `filters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `followables`
--
ALTER TABLE `followables`
  ADD KEY `followables_user_id_foreign` (`user_id`),
  ADD KEY `followables_followable_type_index` (`followable_type`);

--
-- Indexes for table `listings`
--
ALTER TABLE `listings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_additional_options`
--
ALTER TABLE `listing_additional_options`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_booked_dates`
--
ALTER TABLE `listing_booked_dates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_booked_times`
--
ALTER TABLE `listing_booked_times`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_plans`
--
ALTER TABLE `listing_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_plan_payments`
--
ALTER TABLE `listing_plan_payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_services`
--
ALTER TABLE `listing_services`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_shipping_options`
--
ALTER TABLE `listing_shipping_options`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `listing_variants`
--
ALTER TABLE `listing_variants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ltm_translations`
--
ALTER TABLE `ltm_translations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `meta`
--
ALTER TABLE `meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meta_metable_id_index` (`metable_id`),
  ADD KEY `meta_key_index` (`key`);

--
-- Indexes for table `metatags`
--
ALTER TABLE `metatags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `meta_attributes`
--
ALTER TABLE `meta_attributes`
  ADD PRIMARY KEY (`meta_id`),
  ADD KEY `meta_attributes_metable_type_metable_id_index` (`metable_type`,`metable_id`),
  ADD KEY `meta_attributes_meta_key_index` (`meta_key`),
  ADD KEY `meta_attributes_index_value` (`meta_key`,`meta_value`(20));

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_type_model_id_index` (`model_type`,`model_id`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_type_model_id_index` (`model_type`,`model_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders_meta`
--
ALTER TABLE `orders_meta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `page_translations`
--
ALTER TABLE `page_translations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_payable_type_payable_id_index` (`payable_type`,`payable_id`);

--
-- Indexes for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment_providers`
--
ALTER TABLE `payment_providers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plans`
--
ALTER TABLE `plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plan_features`
--
ALTER TABLE `plan_features`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `plan_features_plan_id_code_unique` (`plan_id`,`code`);

--
-- Indexes for table `plan_subscriptions`
--
ALTER TABLE `plan_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_subscriptions_plan_id_foreign` (`plan_id`),
  ADD KEY `plan_subscriptions_subscribable_id_index` (`subscribable_id`),
  ADD KEY `plan_subscriptions_subscribable_type_index` (`subscribable_type`);

--
-- Indexes for table `plan_subscription_usages`
--
ALTER TABLE `plan_subscription_usages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `plan_subscription_usages_subscription_id_code_unique` (`subscription_id`,`code`);

--
-- Indexes for table `pricing_models`
--
ALTER TABLE `pricing_models`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reported_listings`
--
ALTER TABLE `reported_listings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD UNIQUE KEY `sessions_id_unique` (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `settings_key_index` (`key`);

--
-- Indexes for table `taggables`
--
ALTER TABLE `taggables`
  ADD KEY `taggables_tag_id_foreign` (`tag_id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `bitcoin` (`bitcoin`),
  ADD KEY `bitmessage` (`bitmessage`);

--
-- Indexes for table `users_meta`
--
ALTER TABLE `users_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_meta_user_id_index` (`user_id`),
  ADD KEY `users_meta_key_index` (`key`);

--
-- Indexes for table `user_filters`
--
ALTER TABLE `user_filters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wallets_user_id_foreign` (`user_id`);

--
-- Indexes for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wallet_transactions_wallet_id_foreign` (`wallet_id`);

--
-- Indexes for table `widgets`
--
ALTER TABLE `widgets`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `checkout_sessions`
--
ALTER TABLE `checkout_sessions`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=39;
--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=78;
--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `countryid` mediumint unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=439;
--
-- AUTO_INCREMENT for table `custom_files`
--
ALTER TABLE `custom_files`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `filters`
--
ALTER TABLE `filters`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `listings`
--
ALTER TABLE `listings`
  MODIFY `id` bigint unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `listing_additional_options`
--
ALTER TABLE `listing_additional_options`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `listing_booked_dates`
--
ALTER TABLE `listing_booked_dates`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `listing_booked_times`
--
ALTER TABLE `listing_booked_times`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `listing_plans`
--
ALTER TABLE `listing_plans`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `listing_plan_payments`
--
ALTER TABLE `listing_plan_payments`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `listing_services`
--
ALTER TABLE `listing_services`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `listing_shipping_options`
--
ALTER TABLE `listing_shipping_options`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT for table `listing_variants`
--
ALTER TABLE `listing_variants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `ltm_translations`
--
ALTER TABLE `ltm_translations`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=40;
--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=112;
--
-- AUTO_INCREMENT for table `meta`
--
ALTER TABLE `meta`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `metatags`
--
ALTER TABLE `metatags`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `meta_attributes`
--
ALTER TABLE `meta_attributes`
  MODIFY `meta_id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=465;
--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=63;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=90;
--
-- AUTO_INCREMENT for table `orders_meta`
--
ALTER TABLE `orders_meta`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `page_translations`
--
ALTER TABLE `page_translations`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `payment_providers`
--
ALTER TABLE `payment_providers`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `plans`
--
ALTER TABLE `plans`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `plan_features`
--
ALTER TABLE `plan_features`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `plan_subscriptions`
--
ALTER TABLE `plan_subscriptions`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `plan_subscription_usages`
--
ALTER TABLE `plan_subscription_usages`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `pricing_models`
--
ALTER TABLE `pricing_models`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `reported_listings`
--
ALTER TABLE `reported_listings`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=501;
--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `users_meta`
--
ALTER TABLE `users_meta`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `user_filters`
--
ALTER TABLE `user_filters`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  MODIFY `id` int unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `widgets`
--
ALTER TABLE `widgets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `followables`
--
ALTER TABLE `followables`
  ADD CONSTRAINT `followables_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `plan_features`
--
ALTER TABLE `plan_features`
  ADD CONSTRAINT `plan_features_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `plan_subscriptions`
--
ALTER TABLE `plan_subscriptions`
  ADD CONSTRAINT `plan_subscriptions_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `plan_subscription_usages`
--
ALTER TABLE `plan_subscription_usages`
  ADD CONSTRAINT `plan_subscription_usages_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `plan_subscriptions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `taggables`
--
ALTER TABLE `taggables`
  ADD CONSTRAINT `taggables_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users_meta`
--
ALTER TABLE `users_meta`
  ADD CONSTRAINT `users_meta_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD CONSTRAINT `wallet_transactions_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
