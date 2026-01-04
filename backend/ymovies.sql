-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 04, 2026 at 12:25 AM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ymovies`
--

-- --------------------------------------------------------

--
-- Table structure for table `login_history`
--

CREATE TABLE `login_history` (
  `historyId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `login_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `status` enum('success','failed') DEFAULT 'success'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login_history`
--

INSERT INTO `login_history` (`historyId`, `userId`, `login_at`, `ip_address`, `user_agent`, `status`) VALUES
(1, 1, '2026-01-03 12:51:49', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(2, 1, '2026-01-03 13:16:38', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(3, 1, '2026-01-03 18:28:19', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(4, 1, '2026-01-03 19:26:02', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(5, 1, '2026-01-03 21:19:35', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(6, 1, '2026-01-03 21:28:50', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(7, 1, '2026-01-03 21:37:23', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(8, 1, '2026-01-03 21:47:52', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(9, 1, '2026-01-03 21:49:14', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(10, 1, '2026-01-03 21:51:06', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(11, 1, '2026-01-03 21:52:45', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(12, 1, '2026-01-03 21:53:51', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(13, 1, '2026-01-03 21:55:31', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(14, 1, '2026-01-03 21:57:08', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(15, 1, '2026-01-03 21:58:49', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(16, 1, '2026-01-03 22:00:24', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(17, 1, '2026-01-03 22:02:13', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(18, 1, '2026-01-03 22:10:14', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(19, 1, '2026-01-03 22:30:45', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(20, 1, '2026-01-03 22:40:19', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(21, 1, '2026-01-03 22:46:36', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(22, 1, '2026-01-03 22:50:16', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(23, 1, '2026-01-03 22:57:03', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(24, 1, '2026-01-03 23:11:44', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(25, 1, '2026-01-03 23:15:58', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(26, 1, '2026-01-03 23:17:16', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(27, 1, '2026-01-03 23:18:19', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(28, 1, '2026-01-03 23:18:54', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(29, 1, '2026-01-03 23:26:30', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(30, 1, '2026-01-03 23:39:55', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(31, 1, '2026-01-03 23:46:22', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success'),
(32, 1, '2026-01-03 23:50:18', '127.0.0.1', 'Dart/3.9 (dart:io)', 'success');

-- --------------------------------------------------------

--
-- Table structure for table `loved`
--

CREATE TABLE `loved` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `tmdbId` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `poster_path` varchar(255) DEFAULT NULL,
  `release_date` varchar(20) DEFAULT NULL,
  `vote_average` decimal(3,1) DEFAULT NULL,
  `media_type` enum('movie','tv') DEFAULT 'movie',
  `addedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loved`
--

INSERT INTO `loved` (`id`, `userId`, `tmdbId`, `title`, `poster_path`, `release_date`, `vote_average`, `media_type`, `addedAt`) VALUES
(8, 1, 1242898, 'Predator: Badlands', 'https://image.tmdb.org/t/p/w500/ef2QSeBkrYhAdfsWGXmp0lvH0T1.jpg', '2025-11-05', '7.3', 'movie', '2026-01-03 18:25:11'),
(13, 1, 628847, 'Trap House', 'https://image.tmdb.org/t/p/w500/6tpAPeuuqbVnYWWPoOLEDLSBU7a.jpg', '2025-11-14', '6.2', 'movie', '2026-01-03 18:31:10'),
(14, 1, 70672, 'Men on a Mission', 'https://image.tmdb.org/t/p/w500/2jIi55JtYKJTL1km8qHMuUilOWo.jpg', '2015-12-05', '7.5', 'tv', '2026-01-03 18:41:44'),
(15, 1, 1511417, 'Bāhubali: The Epic', 'https://image.tmdb.org/t/p/w500/4sLSorDKKDN944kWngxgQlpdDeg.jpg', '2025-10-29', '6.6', 'movie', '2026-01-03 23:20:22'),
(18, 1, 83533, 'Avatar: Fire and Ash', 'https://image.tmdb.org/t/p/w500/g96wHxU7EnoIFwemb2RgohIXrgW.jpg', '2025-12-17', '7.4', 'movie', '2026-01-03 23:40:44'),
(19, 1, 238, 'The Godfather', 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg', '1972-03-14', '8.7', 'movie', '2026-01-03 23:40:48'),
(20, 1, 240, 'The Godfather Part II', 'https://image.tmdb.org/t/p/w500/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg', '1974-12-20', '8.6', 'movie', '2026-01-03 23:40:50'),
(21, 1, 106379, 'Fallout', 'https://image.tmdb.org/t/p/w500/c15BtJxCXMrISLVmysdsnZUPQft.jpg', '2024-04-10', '8.2', 'tv', '2026-01-03 23:40:52');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userId` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userId`, `firstname`, `lastname`, `email`, `password`, `created_at`) VALUES
(1, 'Youssef', 'Shawwa', 'youssef@gmail.com', '$2y$10$aeOjQoCKnnA6andhklcXsePwiyLq/XoKh6XbUQbH4CY3DW8eCAgry', '2026-01-03 12:27:36');

-- --------------------------------------------------------

--
-- Table structure for table `watchlist`
--

CREATE TABLE `watchlist` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `tmdbId` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `poster_path` varchar(255) DEFAULT NULL,
  `release_date` varchar(20) DEFAULT NULL,
  `vote_average` decimal(3,1) DEFAULT NULL,
  `media_type` enum('movie','tv') DEFAULT 'movie',
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `watchlist`
--

INSERT INTO `watchlist` (`id`, `userId`, `tmdbId`, `title`, `poster_path`, `release_date`, `vote_average`, `media_type`, `added_at`) VALUES
(106, 1, 83533, 'Avatar: Fire and Ash', 'https://image.tmdb.org/t/p/w500/g96wHxU7EnoIFwemb2RgohIXrgW.jpg', '2025-12-17', '7.4', 'movie', '2026-01-03 19:36:47'),
(107, 1, 1223601, 'Sisu: Road to Revenge', 'https://image.tmdb.org/t/p/w500/jNsttCWZyPtW66MjhUozBzVsRb7.jpg', '2025-10-21', '7.5', 'movie', '2026-01-03 23:35:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`historyId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `loved`
--
ALTER TABLE `loved`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_item_unique` (`userId`,`tmdbId`,`media_type`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `watchlist`
--
ALTER TABLE `watchlist`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_item_unique` (`userId`,`tmdbId`,`media_type`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `login_history`
--
ALTER TABLE `login_history`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `loved`
--
ALTER TABLE `loved`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `watchlist`
--
ALTER TABLE `watchlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login_history`
--
ALTER TABLE `login_history`
  ADD CONSTRAINT `login_history_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE;

--
-- Constraints for table `loved`
--
ALTER TABLE `loved`
  ADD CONSTRAINT `loved_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE;

--
-- Constraints for table `watchlist`
--
ALTER TABLE `watchlist`
  ADD CONSTRAINT `watchlist_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
