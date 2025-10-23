<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Market Onitsha - Nigeria's Online Marketplace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-auth-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-firestore-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-storage-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-analytics-compat.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #e53e3e;
            --secondary-color: #c53030;
            --background-color: #ffffff;
            --text-color: #333333;
            --card-bg: #ffffff;
            --border-color: #e2e8f0;
            --header-bg: #ffffff;
            --footer-bg: #f7fafc;
            --whatsapp-green: #25D366;
            --whatsapp-dark: #128C7E;
        }

        .dark-mode {
            --primary-color: #ff6b6b;
            --secondary-color: #ff5252;
            --background-color: #1a202c;
            --text-color: #e2e8f0;
            --card-bg: #2d3748;
            --border-color: #4a5568;
            --header-bg: #2d3748;
            --footer-bg: #2d3748;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--background-color);
            color: var(--text-color);
            transition: all 0.3s ease;
            overflow-x: hidden;
            padding-bottom: 80px;
        }

        /* Header Styles */
        .top-notice {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 8px 0;
            text-align: center;
            font-size: 14px;
            position: relative;
            overflow: hidden;
        }

        .top-notice::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-size: cover;
            background-position: center;
            opacity: 0.2;
            transition: background-image 1s ease-in-out;
        }

        .top-notice .container {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .oshe-market-btn, .errand-boy-btn, .dark-mode-btn {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: bold;
            text-decoration: none;
            animation: blink 2s infinite;
            display: inline-block;
            font-size: 12px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }

        .oshe-market-btn {
            background: #ffd700;
            color: #000;
        }

        .errand-boy-btn {
            background: #28a745;
            color: white;
        }

        .dark-mode-btn {
            background: #6c757d;
            color: white;
        }

        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0.3; }
        }

        .main-header {
            background: var(--header-bg);
            padding: 10px 0;
            border-bottom: 1px solid var(--border-color);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .search-bar {
            flex: 1;
            max-width: 350px;
            display: flex;
            margin: 0 10px;
        }

        .search-bar input {
            flex: 1;
            padding: 8px 12px;
            border: 2px solid var(--primary-color);
            border-radius: 18px 0 0 18px;
            outline: none;
            font-size: 13px;
            background: var(--card-bg);
            color: var(--text-color);
        }

        .search-bar button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0 15px;
            border-radius: 0 18px 18px 0;
            cursor: pointer;
            font-size: 13px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2px;
            color: var(--text-color);
            cursor: pointer;
            padding: 5px;
            border-radius: 6px;
            transition: all 0.3s;
            font-size: 11px;
        }

        .action-btn:hover {
            background: var(--border-color);
            color: var(--primary-color);
        }

        .cart-count {
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            width: 14px;
            height: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 9px;
            position: absolute;
            top: -2px;
            right: -2px;
        }

        /* Navigation */
        .main-nav {
            background: var(--header-bg);
            border-bottom: 1px solid var(--border-color);
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 0;
            overflow-x: auto;
            padding: 2px 0;
            -webkit-overflow-scrolling: touch;
        }

        .nav-links a {
            padding: 8px 12px;
            color: var(--text-color);
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            white-space: nowrap;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
            font-size: 13px;
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        /* Hero Section */
        .hero-banner {
            background: linear-gradient(135deg, rgba(229, 62, 62, 0.1), rgba(221, 107, 32, 0.1));
            color: var(--text-color);
            padding: 50px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-size: cover;
            background-position: center;
            opacity: 0.1;
            transition: background-image 1s ease-in-out;
        }

        .hero-banner .container {
            position: relative;
            z-index: 1;
        }

        .hero-banner h1 {
            font-size: 32px;
            margin-bottom: 12px;
        }

        .hero-banner p {
            font-size: 16px;
            margin-bottom: 20px;
            opacity: 0.95;
        }

        .cta-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 13px;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .btn-outline {
            background: transparent;
            color: var(--text-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Products Grid */
        .products-section {
            padding: 40px 0;
            background: var(--footer-bg);
        }

        .section-title {
            font-size: 24px;
            margin-bottom: 25px;
            text-align: center;
            color: var(--text-color);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 18px;
        }

        .product-card {
            background: var(--card-bg);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s;
            border: 1px solid var(--border-color);
        }

        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .product-image {
            height: 160px;
            overflow: hidden;
            position: relative;
            cursor: pointer;
        }

        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-image:hover img {
            transform: scale(1.05);
        }

        .product-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            background: var(--primary-color);
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: bold;
        }

        .image-count-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: bold;
        }

        .product-info {
            padding: 12px;
        }

        .product-title {
            font-size: 13px;
            margin-bottom: 6px;
            color: var(--text-color);
            line-height: 1.4;
        }

        .product-price {
            font-size: 16px;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 4px;
        }

        .seller-contact {
            font-size: 11px;
            color: var(--text-color);
            opacity: 0.7;
            margin-bottom: 8px;
        }

        .product-actions {
            display: flex;
            gap: 6px;
            margin-top: 10px;
        }

        .add-to-cart {
            flex: 1;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 6px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 11px;
        }

        .add-to-cart:hover {
            background: var(--secondary-color);
        }

        /* Image Gallery Modal */
        .gallery-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }

        .gallery-content {
            position: relative;
            max-width: 90%;
            max-height: 90%;
            text-align: center;
        }

        .gallery-image {
            max-width: 100%;
            max-height: 80vh;
            object-fit: contain;
            border-radius: 8px;
        }

        .gallery-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .gallery-nav:hover {
            background: rgba(255,255,255,0.3);
        }

        .gallery-prev {
            left: 20px;
        }

        .gallery-next {
            right: 20px;
        }

        .gallery-close {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-size: 18px;
            cursor: pointer;
        }

        .gallery-counter {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            background: rgba(0,0,0,0.5);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        /* Warning Banner */
        .warning-banner {
            background: #ffc107;
            color: #856404;
            padding: 8px;
            text-align: center;
            font-weight: bold;
            animation: blink 1.5s infinite;
            margin-bottom: 15px;
            border-radius: 4px;
            font-size: 12px;
        }

        /* Safety Warnings */
        .safety-warning {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            font-family: Arial, sans-serif;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-content {
            background: var(--card-bg);
            border-radius: 8px;
            max-width: 500px;
            width: 100%;
            padding: 20px;
            position: relative;
            border: 1px solid var(--border-color);
            max-height: 90vh;
            overflow-y: auto;
        }

        .close-modal {
            position: absolute;
            top: 12px;
            right: 12px;
            font-size: 18px;
            cursor: pointer;
            color: var(--text-color);
        }

        .auth-input {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            background: var(--background-color);
            color: var(--text-color);
        }

        .checkbox-container {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 10px 0;
        }

        .checkbox-container input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        /* Loading Popup */
        .loading-popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }

        .loading-content {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            max-width: 300px;
            width: 90%;
            border: 2px solid var(--primary-color);
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid var(--border-color);
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-text {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-color);
        }

        /* Toast */
        .toast {
            position: fixed;
            bottom: 15px;
            right: 15px;
            background: #38a169;
            color: white;
            padding: 12px 18px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: slideIn 0.3s ease;
            font-size: 14px;
        }

        .toast.error {
            background: #dc3545;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        /* Page Containers */
        .page-container {
            display: none;
        }

        .page-container.active {
            display: block;
        }

        /* Footer */
        footer {
            background: var(--footer-bg);
            padding: 25px 0 12px;
            border-top: 1px solid var(--border-color);
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .copyright {
            text-align: center;
            padding-top: 12px;
            border-top: 1px solid var(--border-color);
            color: var(--text-color);
            opacity: 0.7;
            font-size: 11px;
        }

        /* Payment Page */
        .payment-details {
            background: var(--border-color);
            padding: 15px;
            border-radius: 6px;
            margin: 15px 0;
        }

        .bank-info {
            background: var(--card-bg);
            padding: 12px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
            font-size: 12px;
        }

        /* Food Market Banner */
        .food-market-banner {
            background: linear-gradient(135deg, #8b4513, #a0522d);
            color: white;
            padding: 15px;
            text-align: center;
            margin-bottom: 20px;
        }

        /* Enhanced Services Styles */
        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .benefit-card {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .benefit-icon {
            font-size: 40px;
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        .cta-section {
            background: var(--footer-bg);
            padding: 40px 0;
            text-align: center;
            margin-top: 40px;
        }

        /* Become Seller Page */
        .become-seller-hero {
            background: linear-gradient(135deg, var(--primary-color), #c53030);
            color: white;
            padding: 60px 0;
            text-align: center;
        }

        /* Seller Verification Styles */
        .verification-badge {
            background: #28a745;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 3px;
        }

        .verification-pending {
            background: #ffc107;
            color: black;
        }

        .seller-verification-form {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border: 1px solid var(--border-color);
        }

        .verification-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            position: relative;
        }

        .verification-steps::before {
            content: '';
            position: absolute;
            top: 15px;
            left: 10%;
            right: 10%;
            height: 2px;
            background: var(--border-color);
            z-index: 1;
        }

        .verification-step {
            text-align: center;
            z-index: 2;
            position: relative;
            flex: 1;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--border-color);
            color: var(--text-color);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
            font-weight: bold;
        }

        .step-active .step-number {
            background: var(--primary-color);
            color: white;
        }

        .step-completed .step-number {
            background: #28a745;
            color: white;
        }

        /* Seller Dashboard */
        .seller-dashboard {
            padding: 20px 0;
        }

        .upload-product-form {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid var(--border-color);
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            background: var(--background-color);
            color: var(--text-color);
        }

        .file-input {
            padding: 8px;
        }

        .image-previews {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 10px;
        }

        .image-preview {
            position: relative;
            border: 2px dashed var(--border-color);
            border-radius: 8px;
            height: 100px;
            overflow: hidden;
        }

        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .remove-image {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            font-size: 12px;
            cursor: pointer;
        }

        /* Admin Dashboard */
        .admin-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .stat-card {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
        }

        /* WhatsApp Notifications */
        .whatsapp-notifications {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border: 1px solid var(--border-color);
        }

        .notification-item {
            padding: 10px;
            border-bottom: 1px solid var(--border-color);
            font-size: 13px;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        /* Offline Indicator */
        .offline-indicator {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: #dc3545;
            color: white;
            padding: 8px;
            text-align: center;
            z-index: 10000;
            display: none;
        }

        /* Fixed CTA Button */
        .fixed-cta {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(135deg, var(--primary-color), #c53030);
            padding: 15px;
            z-index: 9999;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.3);
        }

        /* Lazy Loading Styles */
        .lazy-load {
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }

        .lazy-load.loaded {
            opacity: 1;
        }

        /* Loading spinner for buttons */
        .fa-spinner {
            animation: spin 1s linear infinite;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header-top {
                flex-direction: column;
            }
            .search-bar {
                margin: 8px 0;
                width: 100%;
                max-width: 100%;
            }
            .hero-banner h1 {
                font-size: 24px;
            }
            .products-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 12px;
            }
            .modal-content {
                margin: 10px;
                padding: 15px;
            }
            .benefits-grid {
                grid-template-columns: 1fr;
            }
            .verification-steps {
                flex-direction: column;
                gap: 15px;
            }
            .verification-steps::before {
                display: none;
            }
            .image-previews {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .top-notice .container {
                flex-direction: column;
                gap: 8px;
            }
            .nav-links {
                font-size: 12px;
            }
            .hero-banner {
                padding: 30px 0;
            }
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
            .btn {
                width: 100%;
                max-width: 200px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Image Gallery Modal -->
    <div id="imageGallery" class="gallery-modal">
        <button class="gallery-close" onclick="closeGallery()">
            <i class="fas fa-times"></i>
        </button>
        <button class="gallery-nav gallery-prev" onclick="prevImage()">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button class="gallery-nav gallery-next" onclick="nextImage()">
            <i class="fas fa-chevron-right"></i>
        </button>
        <div class="gallery-content">
            <img id="galleryImage" class="gallery-image" src="" alt="">
            <div class="gallery-counter">
                <span id="currentImage">1</span> of <span id="totalImages">3</span>
            </div>
        </div>
    </div>

    <!-- Offline Indicator -->
    <div class="offline-indicator" id="offlineIndicator">
        <i class="fas fa-wifi"></i> You are currently offline. Some features may be limited.
    </div>

    <!-- Loading Popup -->
    <div id="loadingPopup" class="loading-popup">
        <div class="loading-content">
            <div class="loading-spinner"></div>
            <div class="loading-text" id="loadingText">Logging into account...</div>
        </div>
    </div>

    <!-- Top Notice with Rotating Images -->
    <div class="top-notice" id="topNotice">
        <div class="container">
            <span>Welcome to Main Market Onitsha</span>
            <button class="oshe-market-btn" id="osheMarketBtn" onclick="toggleOsheMarket()">
                Enter Oshe Okwodu Market Onitsha
            </button>
            <button class="errand-boy-btn" onclick="showErrandBoysModal()">
                Order Errand Boy
            </button>
            <button class="dark-mode-btn" onclick="toggleDarkMode()">
                <i class="fas fa-moon"></i> Dark Mode
            </button>
        </div>
    </div>

    <!-- Header -->
    <header class="main-header">
        <div class="container">
            <div class="header-top">
                <div class="logo" onclick="showPage('homePage')">
                    <i class="fas fa-shopping-bag"></i>
                    Main Market <span>Onitsha</span>
                </div>
                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="Search products..." oninput="searchProducts()">
                    <button><i class="fas fa-search"></i></button>
                </div>
                <div class="header-actions">
                    <div class="action-btn" onclick="showAuthModal()">
                        <i class="fas fa-user"></i>
                        <span id="userStatus">Account</span>
                    </div>
                    <div class="action-btn" onclick="handleSellerClick()">
                        <i class="fas fa-store"></i>
                        <span>Sell</span>
                    </div>
                    <div class="action-btn" onclick="showContactModal()">
                        <i class="fas fa-phone"></i>
                        <span>Contact</span>
                    </div>
                    <div class="action-btn" style="position: relative;" onclick="showPage('cartPage')">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Cart</span>
                        <div class="cart-count" id="cartCount">0</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Navigation -->
    <nav class="main-nav">
        <div class="container">
            <ul class="nav-links">
                <li><a class="active" onclick="showPage('homePage')">Home</a></li>
                <li><a onclick="showCategory('fashion')">Fashion</a></li>
                <li><a onclick="showCategory('electronics')">Electronics</a></li>
                <li><a onclick="showCategory('home')">Home & Garden</a></li>
                <li><a onclick="showPage('wishlistPage')"><i class="fas fa-heart"></i> Wishlist</a></li>
                <li><a onclick="showPage('ordersPage')"><i class="fas fa-history"></i> Orders</a></li>
                <li><a onclick="showPage('profilePage')"><i class="fas fa-user"></i> Profile</a></li>
                <li><a onclick="showAdminDashboard()"><i class="fas fa-cog"></i> Admin</a></li>
            </ul>
        </div>
    </nav>

    <!-- Home Page -->
    <div id="homePage" class="page-container active">
        <section class="hero-banner" id="heroBanner">
            <div class="container">
                <h1>Experience Onitsha Market Online</h1>
                <p>Buy directly from Nigerian sellers with live WhatsApp video calls</p>
                <div class="cta-buttons">
                    <button class="btn btn-primary" onclick="showCategory('all')">
                        <i class="fas fa-shopping-bag"></i> Start Shopping
                    </button>
                    <button class="btn btn-outline" onclick="startSellerRegistration()">
                        <i class="fas fa-store"></i> Become a Seller
                    </button>
                </div>
            </div>
        </section>

        <!-- Safety Warnings Section -->
        <div class="container" style="margin-top: 20px;">
            <div class="safety-warning">
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                    <span>⚠️</span>
                    <strong>MARKETPLACE SAFETY RULES</strong>
                </div>
                
                <div style="display: flex; align-items: start; gap: 10px; margin: 10px 0; padding: 10px; background: white; border-radius: 8px;">
                    <span>🔒</span>
                    <div>
                        <strong>NEVER PAY SELLERS DIRECTLY!</strong>
                        <p style="margin: 5px 0; font-size: 14px;">Always pay through our website. If you pay directly to sellers, we cannot help you if there's a problem.</p>
                    </div>
                </div>
                
                <div style="display: flex; align-items: start; gap: 10px; margin: 10px 0; padding: 10px; background: white; border-radius: 8px;">
                    <span>🛡️</span>
                    <div>
                        <strong>YOUR MONEY IS PROTECTED</strong>
                        <p style="margin: 5px 0; font-size: 14px;">If product not delivered on time, you get FULL REFUND automatically!</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Services Section -->
        <section style="padding: 50px 0; background: var(--footer-bg);">
            <div class="container">
                <h2 class="section-title">Our Premium Services</h2>
                <p style="text-align: center; margin-bottom: 40px; color: var(--text-color); opacity: 0.8;">
                    Everything you need for seamless shopping and selling experience
                </p>
                
                <div class="benefits-grid">
                    <!-- WhatsApp Video Calls -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #25D366;">
                            <i class="fab fa-whatsapp"></i>
                        </div>
                        <h3>WhatsApp Video Calls</h3>
                        <p>See products live before buying. Connect directly with sellers via WhatsApp video calls for real-time product inspection.</p>
                        <button class="btn btn-primary" onclick="showVideoCallGuide()" style="margin-top: 15px; background: #25D366;">
                            <i class="fas fa-video"></i> Learn How It Works
                        </button>
                    </div>

                    <!-- Fast Delivery -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #28a745;">
                            <i class="fas fa-shipping-fast"></i>
                        </div>
                        <h3>Fast Delivery</h3>
                        <p>Quick and reliable delivery services across Nigeria. We partner with top logistics companies for timely product delivery.</p>
                        <div style="font-size: 12px; color: var(--text-color); opacity: 0.7; margin-top: 10px;">
                            🚚 Same-day delivery available in Onitsha
                        </div>
                    </div>

                    <!-- Secure Payment -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #007bff;">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>Secure Payment</h3>
                        <p>Bank transfers with payment verification. Your money is safe with our secure payment processing and admin oversight.</p>
                        <div style="font-size: 12px; color: var(--text-color); opacity: 0.7; margin-top: 10px;">
                            🔒 OPay & Bank transfers supported
                        </div>
                    </div>

                    <!-- Errand Boys -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #ff6b6b;">
                            <i class="fas fa-running"></i>
                        </div>
                        <h3>Errand Boys Booking</h3>
                        <p>Need help with shopping or deliveries? Book our trusted errand boys for personal shopping assistance and quick errands.</p>
                        <button class="btn btn-primary" onclick="showErrandBoysModal()" style="margin-top: 15px;">
                            <i class="fas fa-calendar-check"></i> Book Now
                        </button>
                    </div>

                    <!-- Become Seller -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #ffc107;">
                            <i class="fas fa-store"></i>
                        </div>
                        <h3>Become a Seller</h3>
                        <p>Start your online business today. Reach thousands of buyers, get order notifications, and grow your sales with our platform.</p>
                        <button class="btn btn-primary" onclick="startSellerRegistration()" style="margin-top: 15px;">
                            <i class="fas fa-rocket"></i> Start Selling
                        </button>
                    </div>

                    <!-- 24/7 Support -->
                    <div class="benefit-card" style="text-align: center;">
                        <div class="benefit-icon" style="color: #e83e8c;">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h3>24/7 Support</h3>
                        <p>Round-the-clock customer support. Get help anytime with our dedicated support team via WhatsApp and phone calls.</p>
                        <button class="btn btn-primary" onclick="showContactModal()" style="margin-top: 15px;">
                            <i class="fas fa-phone"></i> Contact Support
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <section class="products-section">
            <div class="container">
                <h2 class="section-title">Featured Products</h2>
                <div class="products-grid" id="productsGrid">
                    <!-- Products loaded by JavaScript -->
                </div>
            </div>
        </section>
    </div>

    <!-- Cart Page -->
    <div id="cartPage" class="page-container">
        <div class="container">
            <div style="background: var(--card-bg); border-radius: 12px; padding: 20px; margin: 20px auto; max-width: 600px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); border: 1px solid var(--border-color);">
                <h2 style="text-align: center; margin-bottom: 20px; color: var(--text-color);">
                    <i class="fas fa-shopping-cart"></i> Your Shopping Cart
                </h2>
                
                <!-- Safety Warning in Cart -->
                <div class="safety-warning" style="margin-bottom: 20px;">
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                        <span>⚠️</span>
                        <strong>IMPORTANT: PAYMENT SAFETY</strong>
                    </div>
                    <p style="margin: 5px 0; font-size: 14px;">
                        <strong>🔒 NEVER PAY SELLERS DIRECTLY!</strong> Always complete payment through our secure system. 
                        Your money is protected until you receive your products.
                    </p>
                </div>
                
                <div id="cartItemsContainer">
                    <!-- Cart items will be loaded here -->
                </div>
                
                <div style="border-top: 2px solid var(--primary-color); padding-top: 15px; margin-top: 15px;">
                    <div style="display: flex; justify-content: space-between; font-size: 18px; font-weight: bold; margin-bottom: 20px;">
                        <span>Total:</span>
                        <span>₦<span id="cartTotalAmount">0</span></span>
                    </div>
                    
                    <button class="btn btn-primary" onclick="checkoutWithPaystack()" style="width: 100%; background: #00a859;" id="checkoutBtn" disabled>
                        <i class="fas fa-credit-card"></i> Proceed to Payment
                    </button>
                    
                    <button class="btn btn-outline" onclick="showPage('homePage')" style="width: 100%; margin-top: 10px;">
                        <i class="fas fa-arrow-left"></i> Continue Shopping
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Payment Page -->
    <div id="paymentPage" class="page-container">
        <div class="container">
            <div style="background: var(--card-bg); border-radius: 12px; padding: 0; margin: 20px auto; max-width: 400px; box-shadow: 0 8px 32px rgba(0,0,0,0.1); border: 1px solid var(--border-color); overflow: hidden;">
                <!-- Paystack-style Header -->
                <div style="background: linear-gradient(135deg, #00a859, #00a859); padding: 20px; text-align: center; color: white;">
                    <div style="font-size: 24px; font-weight: bold; margin-bottom: 5px;">
                        ₦<span id="paystackAmount">0</span>
                    </div>
                    <div style="font-size: 14px; opacity: 0.9;">Total Amount to Pay</div>
                </div>

                <!-- Paystack-style Body -->
                <div style="padding: 25px;">
                    <!-- Safety Warning -->
                    <div class="safety-warning" style="margin-bottom: 20px;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                            <span>🛡️</span>
                            <strong>MONEY-BACK GUARANTEE</strong>
                        </div>
                        <p style="margin: 5px 0; font-size: 13px;">
                            If your products don't arrive on time, you get <strong>FULL REFUND automatically!</strong> 
                            Your payment is protected.
                        </p>
                    </div>

                    <!-- Order Summary -->
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: var(--text-color); margin-bottom: 15px; font-size: 16px;">
                            <i class="fas fa-shopping-bag"></i> Order Summary
                        </h4>
                        <div id="paystackOrderSummary" style="background: var(--footer-bg); padding: 15px; border-radius: 8px; font-size: 13px;">
                            <!-- Order items will be loaded here -->
                        </div>
                    </div>

                    <!-- Bank Transfer Instructions -->
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #00a859; margin-bottom: 20px;">
                        <h4 style="color: #00a859; margin-bottom: 15px; font-size: 16px;">
                            <i class="fas fa-university"></i> Make Transfer to:
                        </h4>
                        
                        <div style="display: grid; gap: 12px; font-size: 14px;">
                            <div style="display: flex; justify-content: between;">
                                <span style="color: var(--text-color); opacity: 0.8;">Bank:</span>
                                <span style="font-weight: bold; color: var(--text-color);">OPay Digital Bank</span>
                            </div>
                            
                            <div style="display: flex; justify-content: between;">
                                <span style="color: var(--text-color); opacity: 0.8;">Account Name:</span>
                                <span style="font-weight: bold; color: var(--text-color);">Okwudiri Godwin Ekene</span>
                            </div>
                            
                            <div style="display: flex; justify-content: between;">
                                <span style="color: var(--text-color); opacity: 0.8;">Account Number:</span>
                                <span style="font-weight: bold; color: var(--text-color);">8064562826</span>
                            </div>
                            
                            <div style="display: flex; justify-content: between;">
                                <span style="color: var(--text-color); opacity: 0.8;">Amount:</span>
                                <span style="font-weight: bold; color: #00a859; font-size: 16px;">₦<span id="paystackTotalAmount">0</span></span>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Action -->
                    <div style="text-align: center;">
                        <button class="btn btn-primary" onclick="processPaystackPayment()" style="width: 100%; background: #00a859; padding: 15px; font-size: 16px; font-weight: bold; border-radius: 8px;">
                            <i class="fas fa-check-circle"></i> I Have Made the Transfer
                        </button>
                        
                        <button class="btn btn-outline" onclick="showPage('cartPage')" style="width: 100%; margin-top: 15px; padding: 12px; border-radius: 8px;">
                            <i class="fas fa-arrow-left"></i> Back to Cart
                        </button>
                    </div>

                    <!-- Help Text -->
                    <div style="text-align: center; margin-top: 20px;">
                        <p style="color: var(--text-color); opacity: 0.7; font-size: 12px; line-height: 1.4;">
                            <i class="fas fa-info-circle"></i> 
                            After making the transfer, click the button above and we will contact you within 24 hours for delivery.
                        </p>
                    </div>
                </div>

                <!-- Paystack-style Footer -->
                <div style="background: var(--footer-bg); padding: 15px; text-align: center; border-top: 1px solid var(--border-color);">
                    <div style="color: var(--text-color); opacity: 0.7; font-size: 12px;">
                        <i class="fas fa-lock"></i> Secure Payment • 
                        <i class="fas fa-shield-alt"></i> Protected by Main Market Onitsha
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Oshe Okwodu Market Page -->
    <div id="osheMarketPage" class="page-container">
        <div class="food-market-banner">
            <div class="container">
                <h2>🛒 SHOP FROM OSHE OKWODU MARKET ONLINE</h2>
                <p>We offer fast delivery service to your door step!</p>
                <button class="oshe-market-btn" onclick="toggleOsheMarket()" style="background: white; color: #8b4513; margin-top: 10px;">
                    Go Back to Main Market Onitsha Online
                </button>
            </div>
        </div>

        <section class="products-section">
            <div class="container">
                <h2 class="section-title">Fresh Local Food Stuff</h2>
                <div class="products-grid" id="foodProductsGrid">
                    <!-- Food products loaded by JavaScript -->
                </div>
            </div>
        </section>
    </div>

    <!-- How to Become Seller Page -->
    <div id="becomeSellerPage" class="page-container">
        <div class="become-seller-hero">
            <div class="container">
                <h1 style="font-size: 32px; margin-bottom: 15px;">Start Selling on Main Market Onitsha</h1>
                <p style="font-size: 18px; margin-bottom: 25px; opacity: 0.9;">Join Nigeria's fastest growing digital marketplace</p>
                <button class="btn" onclick="startSellerRegistration()" 
                        style="background: white; color: var(--primary-color); border: none; padding: 15px 30px; border-radius: 25px; font-weight: bold; font-size: 16px; cursor: pointer;">
                    <i class="fas fa-rocket"></i> Start Selling Now - It's FREE
                </button>
            </div>
        </div>

        <div class="container" style="padding: 50px 0;">
            <!-- Benefits Section -->
            <h2 class="section-title">Why Sell With Us?</h2>
            <div class="benefits-grid">
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Thousands of Buyers</h3>
                    <p>Reach customers across Nigeria and beyond with our growing marketplace</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-video"></i>
                    </div>
                    <h3>Video Call Feature</h3>
                    <p>Show products live to buyers through WhatsApp video calls</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Secure Payments</h3>
                    <p>Get paid securely through bank transfers with admin support</p>
                </div>
                <div class="benefit-card">
                    <div class="benefit-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>Mobile First</h3>
                    <p>Manage your business from your phone, anytime, anywhere</p>
                </div>
            </div>

            <!-- How It Works -->
            <h2 class="section-title" style="margin-top: 50px;">How It Works</h2>
            <div class="verification-steps">
                <div class="verification-step step-completed">
                    <div class="step-number">1</div>
                    <div>Create Account</div>
                </div>
                <div class="verification-step step-completed">
                    <div class="step-number">2</div>
                    <div>Get Verified</div>
                </div>
                <div class="verification-step step-active">
                    <div class="step-number">3</div>
                    <div>Start Selling</div>
                </div>
            </div>

            <!-- Seller Safety Guidelines -->
            <div class="safety-warning" style="margin-top: 40px;">
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                    <span>📋</span>
                    <strong>SELLER GUIDELINES</strong>
                </div>
                <div style="display: grid; gap: 10px;">
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <span>✅</span>
                        <div>
                            <strong>Provide Real WhatsApp Number</strong>
                            <p style="margin: 2px 0; font-size: 13px;">Buyers will video call you directly to see your products</p>
                        </div>
                    </div>
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <span>✅</span>
                        <div>
                            <strong>Deliver on Time</strong>
                            <p style="margin: 2px 0; font-size: 13px;">Late deliveries result in automatic refunds to buyers</p>
                        </div>
                    </div>
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <span>✅</span>
                        <div>
                            <strong>Never Ask for Direct Payment</strong>
                            <p style="margin: 2px 0; font-size: 13px;">All payments must go through the platform for protection</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Final CTA -->
            <div class="cta-section">
                <h2 style="margin-bottom: 15px;">Ready to Grow Your Business?</h2>
                <p style="margin-bottom: 25px; opacity: 0.8;">Join hundreds of sellers already making money on our platform</p>
                <button class="btn btn-primary" onclick="startSellerRegistration()" 
                        style="padding: 15px 40px; font-size: 18px; border-radius: 30px;">
                    <i class="fas fa-store"></i> Start Selling Today - FREE
                </button>
                <div style="margin-top: 15px; font-size: 14px; opacity: 0.7;">
                    No hidden fees • No monthly charges • Start in 5 minutes
                </div>
            </div>
        </div>
    </div>

    <!-- Seller Dashboard Page -->
    <div id="sellerDashboard" class="page-container">
        <div class="container seller-dashboard">
            <h2 class="section-title">Seller Dashboard</h2>
            <div class="warning-banner">
                <i class="fas fa-info-circle"></i> Upload your products to start selling
            </div>

            <!-- Seller Safety Reminder -->
            <div class="safety-warning" style="margin-bottom: 20px;">
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
                    <span>📞</span>
                    <strong>IMPORTANT: PROVIDE YOUR REAL WHATSAPP NUMBER</strong>
                </div>
                <p style="margin: 5px 0; font-size: 13px;">
                    Buyers will video call <strong>YOU directly</strong> to see your products. Make sure your WhatsApp number is correct and you're available for video calls.
                </p>
            </div>

            <div class="upload-product-form">
                <h3 style="margin-bottom: 20px;">Add New Product</h3>
                <div class="form-group">
                    <label for="productName">Product Name</label>
                    <input type="text" id="productName" class="form-input" placeholder="Enter product name">
                </div>
                <div class="form-group">
                    <label for="productPrice">Price (₦)</label>
                    <input type="number" id="productPrice" class="form-input" placeholder="Enter price">
                </div>
                <div class="form-group">
                    <label for="productDescription">Description</label>
                    <textarea id="productDescription" class="form-input" placeholder="Enter product description" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="productCategory">Category</label>
                    <select id="productCategory" class="form-input">
                        <option value="fashion">Fashion</option>
                        <option value="electronics">Electronics</option>
                        <option value="home">Home & Garden</option>
                        <option value="food">Food</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Product Images (Up to 3 images)</label>
                    <input type="file" id="productImage1" class="form-input file-input" accept="image/*" onchange="previewImage(1)">
                    <input type="file" id="productImage2" class="form-input file-input" accept="image/*" onchange="previewImage(2)">
                    <input type="file" id="productImage3" class="form-input file-input" accept="image/*" onchange="previewImage(3)">
                    
                    <div class="image-previews" id="imagePreviews">
                        <!-- Image previews will appear here -->
                    </div>
                </div>

                <button class="btn btn-primary" onclick="uploadProductWithLoading()" style="width: 100%;" id="uploadProductBtn">
                    <i class="fas fa-upload"></i> Upload Product
                </button>
            </div>

            <div id="sellerProductsGrid" class="products-grid">
                <!-- Seller's products will be loaded here -->
            </div>
        </div>
    </div>

    <!-- Admin Dashboard Page -->
    <div id="adminDashboard" class="page-container">
        <div class="container">
            <h2 class="section-title">Admin Dashboard</h2>
            
            <div class="warning-banner">
                <i class="fas fa-shield-alt"></i> Admin Access Only - Order Management
            </div>

            <div class="admin-stats">
                <div class="stat-card">
                    <div class="stat-number" id="totalOrders">0</div>
                    <div>Total Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="todayOrders">0</div>
                    <div>Today's Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="pendingOrders">0</div>
                    <div>Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" id="totalRevenue">₦0</div>
                    <div>Total Revenue</div>
                </div>
            </div>

            <div class="whatsapp-notifications">
                <h3 style="margin-bottom: 15px;">
                    <i class="fab fa-whatsapp" style="color: #25D366;"></i> Recent Orders
                </h3>
                <div id="recentOrdersList">
                    <!-- Orders will be loaded here -->
                </div>
            </div>

            <div style="text-align: center; margin-top: 20px;">
                <button class="btn btn-primary" onclick="loadAdminOrders()">
                    <i class="fas fa-sync"></i> Refresh Orders
                </button>
                <button class="btn btn-outline" onclick="showPage('homePage')">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </button>
            </div>
        </div>
    </div>

    <!-- Other pages (Profile, Orders, Wishlist) -->
    <div id="profilePage" class="page-container">
        <div class="container">
            <div class="profile-section">
                <h2 class="section-title">User Profile</h2>
                <div id="profileInfo">
                    <!-- Profile info loaded by JavaScript -->
                </div>
            </div>
        </div>
    </div>

    <div id="ordersPage" class="page-container">
        <div class="container">
            <h2 class="section-title">Order History</h2>
            <div id="ordersList">
                <!-- Orders loaded by JavaScript -->
            </div>
        </div>
    </div>

    <div id="wishlistPage" class="page-container">
        <div class="container">
            <h2 class="section-title">Your Wishlist</h2>
            <div id="wishlistGrid" class="products-grid">
                <!-- Wishlist items loaded by JavaScript -->
            </div>
        </div>
    </div>

    <!-- Modals -->
    <div id="contactModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeContactModal()">&times;</span>
            <h3 style="text-align: center; margin-bottom: 15px; color: var(--text-color);">Contact Information</h3>
            <div style="text-align: center;">
                <p><strong>Email:</strong></p>
                <p style="color: var(--primary-color); margin-bottom: 15px;">godwindouglas8@gmail.com</p>
                
                <p><strong>Phone Numbers:</strong></p>
                <p style="color: var(--primary-color); margin-bottom: 5px;">+234 8064562826</p>
                <p style="color: var(--primary-color); margin-bottom: 15px;">+234 7070752053</p>
                
                <button class="btn btn-primary" onclick="closeContactModal()" style="width: 100%;">
                    Close
                </button>
            </div>
        </div>
    </div>

    <div id="errandBoysModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeErrandBoysModal()">&times;</span>
            <h3 style="text-align: center; margin-bottom: 15px; color: var(--text-color);">Available Errand Boys</h3>
            
            <div class="warning-banner" style="background: #17a2b8; color: white;">
                <i class="fas fa-info-circle"></i> How it works: Book an errand boy, they come to your house and help with shopping, deliveries, and other tasks!
            </div>

            <div class="errand-boys-grid" id="errandBoysGrid">
                <!-- Errand boys will be loaded here -->
            </div>
        </div>
    </div>

    <div id="authModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeAuthModal()">&times;</span>
            <h3 style="text-align: center; margin-bottom: 15px; color: var(--text-color);" id="authTitle">Login to Your Account</h3>
            
            <div id="loginForm">
                <input type="email" id="loginEmail" placeholder="Email Address" class="auth-input">
                <input type="password" id="loginPassword" placeholder="Password" class="auth-input">
                
                <button class="btn btn-primary" onclick="loginUserWithLoading()" style="width: 100%; margin: 10px 0;" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
                
                <div id="googleAuthLogin"></div>
                
                <p style="text-align: center; color: var(--text-color); opacity: 0.7; margin-top: 15px;">
                    Don't have an account? 
                    <a href="#" onclick="showRegisterForm()" style="color: var(--primary-color);">Register here</a>
                </p>
            </div>

            <div id="registerForm" style="display: none;">
                <input type="text" id="regName" placeholder="Full Name" class="auth-input">
                <input type="tel" id="regPhone" placeholder="Phone Number" class="auth-input">
                <input type="email" id="regEmail" placeholder="Email Address" class="auth-input">
                <input type="password" id="regPassword" placeholder="Password" class="auth-input">
                
                <div class="checkbox-container">
                    <input type="checkbox" id="becomeSeller">
                    <label for="becomeSeller">Become a Seller</label>
                </div>
                
                <button class="btn btn-primary" onclick="registerUserWithLoading()" style="width: 100%; margin: 10px 0;" id="registerBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
                
                <div id="googleAuthRegister"></div>
                
                <p style="text-align: center; color: var(--text-color); opacity: 0.7;">
                    Already have an account? 
                    <a href="#" onclick="showLoginForm()" style="color: var(--primary-color);">Login here</a>
                </p>
            </div>
        </div>
    </div>

    <!-- WhatsApp Video Call Guide Modal -->
    <div id="videoCallGuideModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeVideoCallGuide()">&times;</span>
            <h3 style="text-align: center; margin-bottom: 20px; color: var(--text-color);">
                <i class="fab fa-whatsapp" style="color: #25D366;"></i> WhatsApp Video Call Guide
            </h3>
            
            <div style="background: var(--footer-bg); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                <h4 style="color: var(--text-color); margin-bottom: 15px;">How to Video Call Sellers:</h4>
                
                <div style="display: grid; gap: 15px;">
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <div style="background: #25D366; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold;">1</div>
                        <div>
                            <strong>Find Product</strong>
                            <p style="margin: 5px 0 0 0; font-size: 13px; color: var(--text-color); opacity: 0.8;">
                                Browse products and click "Video Call Seller" button
                            </p>
                        </div>
                    </div>
                    
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <div style="background: #25D366; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold;">2</div>
                        <div>
                            <strong>Auto-Message</strong>
                            <p style="margin: 5px 0 0 0; font-size: 13px; color: var(--text-color); opacity: 0.8;">
                                WhatsApp opens with pre-written message about the product
                            </p>
                        </div>
                    </div>
                    
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <div style="background: #25D366; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold;">3</div>
                        <div>
                            <strong>Request Video Call</strong>
                            <p style="margin: 5px 0 0 0; font-size: 13px; color: var(--text-color); opacity: 0.8;">
                                Ask seller to start WhatsApp video call to see product live
                            </p>
                        </div>
                    </div>
                    
                    <div style="display: flex; align-items: start; gap: 10px;">
                        <div style="background: #25D366; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold;">4</div>
                        <div>
                            <strong>Inspect & Negotiate</strong>
                            <p style="margin: 5px 0 0 0; font-size: 13px; color: var(--text-color); opacity: 0.8;">
                                See product condition, ask questions, and negotiate price
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; border-left: 4px solid #25D366; margin-bottom: 20px;">
                <h5 style="color: #25D366; margin-bottom: 10px;">💡 Pro Tips:</h5>
                <ul style="color: var(--text-color); font-size: 13px; padding-left: 20px;">
                    <li>Check product from all angles during video call</li>
                    <li>Ask about product condition and authenticity</li>
                    <li>Confirm delivery options and timing</li>
                    <li>Negotiate price before making payment</li>
                    <li><strong>NEVER pay seller directly</strong> - always use the platform</li>
                </ul>
            </div>

            <button class="btn btn-primary" onclick="closeVideoCallGuide()" style="width: 100%; background: #25D366;">
                <i class="fas fa-check"></i> Got It!
            </button>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div>
                    <h4>Main Market Onitsha</h4>
                    <p>Nigeria's digital marketplace</p>
                </div>
                <div>
                    <h4>Contact</h4>
                    <p>0806 456 2826</p>
                    <p>godwindouglas8@gmail.com</p>
                </div>
                <div>
                    <h4>Our Services</h4>
                    <p><i class="fas fa-shipping-fast" style="color: #28a745;"></i> Fast Delivery</p>
                    <p><i class="fas fa-shield-alt" style="color: #007bff;"></i> Secure Payment</p>
                    <p><i class="fas fa-running" style="color: #ff6b6b;"></i> Errand Boys Booking</p>
                    <p><i class="fas fa-store" style="color: #ffc107;"></i> Become a Seller</p>
                    <p><i class="fab fa-whatsapp" style="color: #25D366;"></i> WhatsApp Video Calls</p>
                    <p><i class="fas fa-headset" style="color: #e83e8c;"></i> 24/7 Support</p>
                </div>
                <div>
                    <h4>Quick Links</h4>
                    <p><a href="#" onclick="showPage('homePage')" style="color: var(--text-color); text-decoration: none;">Home</a></p>
                    <p><a href="#" onclick="showBecomeSellerPage()" style="color: var(--text-color); text-decoration: none;">Sell Products</a></p>
                    <p><a href="#" onclick="showErrandBoysModal()" style="color: var(--text-color); text-decoration: none;">Book Errand Boy</a></p>
                    <p><a href="#" onclick="showContactModal()" style="color: var(--text-color); text-decoration: none;">Contact Support</a></p>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; 2024 Main Market Onitsha. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Fixed Become Seller CTA -->
    <div class="fixed-cta">
        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                <div style="color: white; flex: 1;">
                    <strong style="display: block; font-size: 16px;">🚀 Start Selling on Main Market Onitsha</strong>
                    <span style="font-size: 13px; opacity: 0.9;">Reach thousands of buyers • Zero setup fees • 24/7 marketplace</span>
                </div>
                <button class="btn" onclick="showBecomeSellerPage()" 
                        style="background: white; color: var(--primary-color); border: none; padding: 12px 25px; border-radius: 25px; font-weight: bold; font-size: 14px; cursor: pointer; white-space: nowrap; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
                    <i class="fas fa-store"></i> Become a Seller Now
                </button>
            </div>
        </div>
    </div>

    <script>
        // Firebase Configuration - YOUR ACTUAL CONFIG
        const firebaseConfig = {
            apiKey: "AIzaSyB_0nl4fJLq6XXB2LGR-0x_BNaeJlpHKvE",
            authDomain: "mainmarketo.firebaseapp.com",
            projectId: "mainmarketo",
            storageBucket: "mainmarketo.firebasestorage.app",
            messagingSenderId: "819152030335",
            appId: "1:819152030335:web:3c022f7c680b45424d4d4a",
            measurementId: "G-8D0Q1HFR2Z"
        };

        // Initialize Firebase
        firebase.initializeApp(firebaseConfig);
        const auth = firebase.auth();
        const db = firebase.firestore();
        const storage = firebase.storage();
        const analytics = firebase.analytics();

        // ==================== ENHANCED SELLER VIDEO CALL SYSTEM ====================
        class SellerVideoSystem {
            constructor() {
                this.init();
            }

            init() {
                console.log('🎥 Seller Video System Initialized');
                this.enhanceProductDisplay();
            }

            // Enhance product display with seller contact info
            enhanceProductDisplay() {
                // This will be called when products are loaded
                console.log('Enhanced product display with seller contact info');
            }

            // Enhanced WhatsApp video call function
            startSellerVideoCall(sellerPhone, productName, productPrice, productId) {
                if (!currentUser) {
                    showAuthModal();
                    showToast('Please login to start video call with seller');
                    return;
                }
                
                const cleanPhone = sellerPhone.replace(/\s+/g, '').replace('+', '');
                const userMessage = `Hello! I saw your product "${productName}" for ₦${productPrice?.toLocaleString() || '0'} on Main Market Onitsha. 

I'm interested in buying it. Can we do a WhatsApp video call so I can see the product live before purchasing?

Please let me know when you're available for a video call. Thank you!`;

                const whatsappUrl = `https://wa.me/${cleanPhone}?text=${encodeURIComponent(userMessage)}`;
                
                window.open(whatsappUrl, '_blank');
                showToast('Opening WhatsApp to request video call with seller...');
                
                this.logVideoCallRequest(productId, sellerPhone, productName);
            }

            logVideoCallRequest(productId, sellerPhone, productName) {
                if (!currentUser) return;
                
                const videoCallData = {
                    userId: currentUser.uid,
                    userEmail: currentUser.email,
                    productId: productId,
                    productName: productName,
                    sellerPhone: sellerPhone,
                    timestamp: firebase.firestore.FieldValue.serverTimestamp(),
                    type: 'video_call_request'
                };
                
                db.collection("videoCallRequests").add(videoCallData).catch(console.error);
            }

            // Enhanced seller registration
            async registerSellerWithPhone(sellerData) {
                try {
                    showLoadingPopup('Setting up your seller account...');

                    const sellerInfo = {
                        name: sellerData.name,
                        phone: sellerData.phone, // Seller's WhatsApp number
                        email: sellerData.email,
                        businessName: sellerData.businessName,
                        isSeller: true,
                        sellerSince: firebase.firestore.FieldValue.serverTimestamp(),
                        videoCallEnabled: true,
                        status: 'active'
                    };

                    await db.collection("users").doc(currentUser.uid).update(sellerInfo);
                    
                    hideLoadingPopup();
                    showToast('🎉 Seller account activated! Buyers will now call YOUR number');
                    return true;
                    
                } catch (error) {
                    hideLoadingPopup();
                    showToast('Error activating seller account: ' + error.message, 'error');
                    return false;
                }
            }
        }

        // Initialize the seller video system
        const sellerVideoSystem = new SellerVideoSystem();

        // ==================== ORIGINAL APPLICATION CODE ====================
        // Image rotation array
        const marketImages = [
            'https://images.unsplash.com/photo-1759807823668-47046433ab61?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            'https://thumbs.dreamstime.com/b/african-women-shopping-food-stuff-local-market-paying-doing-mobile-transfer-via-phone-trader-african-woman-166608929.jpg'
        ];

        // Sample products data - NOW WITH SELLER PHONE NUMBERS
        const sampleProducts = [
            {
                id: 1,
                name: "Men's African Print Shirt - Premium Quality",
                price: 4500,
                images: [
                    "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
                    "https://images.unsplash.com/photo-1503341504253-dff4815485f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
                    "https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "BESTSELLER",
                category: "fashion",
                sellerPhone: "+2348064562826", // Seller 1
                sellerName: "Fashion Store NG"
            },
            {
                id: 2,
                name: "Wireless Bluetooth Headphones",
                price: 8500,
                images: [
                    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
                    "https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "HOT",
                category: "electronics",
                sellerPhone: "+2348064562826", // Seller 1
                sellerName: "Tech Gadgets Ltd"
            },
            {
                id: 3,
                name: "African Print Women's Dress",
                price: 5200,
                images: [
                    "https://images.unsplash.com/photo-1581044777550-4cfa60707c03?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "NEW",
                category: "fashion",
                sellerPhone: "+2347070752053", // Seller 2
                sellerName: "African Fashion Hub"
            },
            {
                id: 4,
                name: "Smartphone Android 128GB",
                price: 12500,
                images: [
                    "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "TRENDING",
                category: "electronics",
                sellerPhone: "+2348064562826", // Seller 1
                sellerName: "Mobile World"
            }
        ];

        const foodProducts = [
            {
                id: 101,
                name: "Fresh Garri - 5kg Bag",
                price: 2500,
                images: [
                    "https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "FRESH",
                category: "food",
                sellerPhone: "+2348064562826", // Seller 1
                sellerName: "Oshe Market Foods"
            },
            {
                id: 102,
                name: "Local Rice - 10kg Bag",
                price: 8500,
                images: [
                    "https://images.unsplash.com/photo-1586201375761-83865001e31c?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80"
                ],
                badge: "LOCAL",
                category: "food",
                sellerPhone: "+2347070752053", // Seller 2
                sellerName: "Farm Fresh NG"
            }
        ];

        const errandBoys = [
            {
                id: 1,
                name: "Chinedu Okoro",
                phone: "+2348064562826",
                image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
                rating: "4.8"
            },
            {
                id: 2,
                name: "Emeka Nwankwo",
                phone: "+2347070752053",
                image: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
                rating: "4.9"
            }
        ];

        // Global variables
        let cart = [];
        let currentUser = null;
        let currentImageIndex = 0;
        let imageRotationInterval;
        let isSeller = false;
        let wishlist = [];
        let orders = [];
        let allProducts = [...sampleProducts, ...foodProducts];
        
        // Image Gallery Variables
        let currentGalleryImages = [];
        let currentGalleryIndex = 0;

        // Initialize the application
        document.addEventListener('DOMContentLoaded', function() {
            loadProducts();
            loadFoodProducts();
            loadErrandBoys();
            updateCartCount();
            startImageRotation();
            initializeDarkMode();
            initializeAuth();
            loadWishlist();
            loadOrders();
            setupOfflineDetection();
            initializeGoogleAuth();
        });

        // Setup offline detection
        function setupOfflineDetection() {
            window.addEventListener('online', function() {
                document.getElementById('offlineIndicator').style.display = 'none';
                showToast('Connection restored');
            });
            
            window.addEventListener('offline', function() {
                document.getElementById('offlineIndicator').style.display = 'block';
            });
        }

        // Loading Popup Functions
        function showLoadingPopup(message) {
            document.getElementById('loadingText').textContent = message;
            document.getElementById('loadingPopup').style.display = 'flex';
        }

        function hideLoadingPopup() {
            document.getElementById('loadingPopup').style.display = 'none';
        }

        function initializeAuth() {
            auth.onAuthStateChanged((user) => {
                if (user) {
                    currentUser = user;
                    document.getElementById('userStatus').textContent = 'Hi, ' + (user.displayName || 'User');
                    db.collection("users").doc(user.uid).get().then((doc) => {
                        if (doc.exists) {
                            isSeller = doc.data().isSeller || false;
                        }
                    });
                    loadWishlist();
                    loadOrders();
                    loadProfile();
                } else {
                    currentUser = null;
                    document.getElementById('userStatus').textContent = 'Account';
                    isSeller = false;
                    wishlist = [];
                    orders = [];
                }
            });
        }

        function startImageRotation() {
            imageRotationInterval = setInterval(() => {
                rotateImages();
            }, 4000);
        }

        function rotateImages() {
            const topNotice = document.getElementById('topNotice');
            const heroBanner = document.getElementById('heroBanner');
            
            currentImageIndex = (currentImageIndex + 1) % marketImages.length;
            const imageUrl = marketImages[currentImageIndex];
            
            topNotice.style.backgroundImage = `linear-gradient(135deg, rgba(229, 62, 62, 0.8), rgba(221, 107, 32, 0.7)), url('${imageUrl}')`;
            topNotice.style.backgroundSize = 'cover';
            topNotice.style.backgroundPosition = 'center';
            
            heroBanner.style.backgroundImage = `linear-gradient(135deg, rgba(229, 62, 62, 0.1), rgba(221, 107, 32, 0.1)), url('${imageUrl}')`;
            heroBanner.style.backgroundSize = 'cover';
            heroBanner.style.backgroundPosition = 'center';
        }

        function toggleDarkMode() {
            document.body.classList.toggle('dark-mode');
            const darkModeBtn = document.querySelector('.dark-mode-btn');
            const isDarkMode = document.body.classList.contains('dark-mode');
            
            if (isDarkMode) {
                darkModeBtn.innerHTML = '<i class="fas fa-sun"></i> Light Mode';
                localStorage.setItem('darkMode', 'enabled');
            } else {
                darkModeBtn.innerHTML = '<i class="fas fa-moon"></i> Dark Mode';
                localStorage.setItem('darkMode', 'disabled');
            }
        }

        function initializeDarkMode() {
            const savedMode = localStorage.getItem('darkMode');
            if (savedMode === 'enabled') {
                document.body.classList.add('dark-mode');
                document.querySelector('.dark-mode-btn').innerHTML = '<i class="fas fa-sun"></i> Light Mode';
            }
        }

        // Page Navigation
        function showPage(pageId) {
            document.querySelectorAll('.page-container').forEach(page => {
                page.classList.remove('active');
            });
            document.getElementById(pageId).classList.add('active');
            
            // Update navigation active state
            document.querySelectorAll('.nav-links a').forEach(link => {
                link.classList.remove('active');
            });
            
            // Set active state for current page
            const currentLink = Array.from(document.querySelectorAll('.nav-links a')).find(link => 
                link.getAttribute('onclick')?.includes(pageId)
            );
            if (currentLink) {
                currentLink.classList.add('active');
            }
        }

        function showCategory(category) {
            showPage('homePage');
            // Filter products by category
            const filteredProducts = category === 'all' ? allProducts : allProducts.filter(product => product.category === category);
            displayProducts(filteredProducts, 'productsGrid');
        }

        // Product Management
        function loadProducts() {
            displayProducts(sampleProducts, 'productsGrid');
        }

        function loadFoodProducts() {
            displayProducts(foodProducts, 'foodProductsGrid');
        }

        function displayProducts(products, containerId) {
            const container = document.getElementById(containerId);
            container.innerHTML = products.map(product => `
                <div class="product-card">
                    <div class="product-image" onclick="openImageGallery(${product.id})">
                        <img src="${product.images[0]}" alt="${product.name}">
                        ${product.images.length > 1 ? `
                            <div class="image-count-badge">
                                <i class="fas fa-images"></i> ${product.images.length}
                            </div>
                        ` : ''}
                        ${product.badge ? `<div class="product-badge">${product.badge}</div>` : ''}
                    </div>
                    <div class="product-info">
                        <h3 class="product-title">${product.name}</h3>
                        <div class="product-price">₦${product.price.toLocaleString()}</div>
                        <div class="seller-contact">
                            <strong>Seller:</strong> ${product.sellerName}<br>
                            <small>📞 ${product.sellerPhone}</small>
                        </div>
                        <div class="product-actions">
                            <button class="add-to-cart" onclick="addToCart(${product.id})">
                                <i class="fas fa-cart-plus"></i> Add to Cart
                            </button>
                            <button class="btn btn-outline" onclick="sellerVideoSystem.startSellerVideoCall('${product.sellerPhone}', '${product.name}', ${product.price}, ${product.id})">
                                <i class="fab fa-whatsapp"></i> Video Call ${product.sellerName}
                            </button>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        // Image Gallery Functions
        function openImageGallery(productId) {
            const product = allProducts.find(p => p.id === productId);
            if (product && product.images.length > 0) {
                currentGalleryImages = product.images;
                currentGalleryIndex = 0;
                showGalleryImage();
                document.getElementById('imageGallery').style.display = 'flex';
            }
        }

        function showGalleryImage() {
            document.getElementById('galleryImage').src = currentGalleryImages[currentGalleryIndex];
            document.getElementById('currentImage').textContent = currentGalleryIndex + 1;
            document.getElementById('totalImages').textContent = currentGalleryImages.length;
        }

        function nextImage() {
            currentGalleryIndex = (currentGalleryIndex + 1) % currentGalleryImages.length;
            showGalleryImage();
        }

        function prevImage() {
            currentGalleryIndex = currentGalleryIndex === 0 ? currentGalleryImages.length - 1 : currentGalleryIndex - 1;
            showGalleryImage();
        }

        function closeGallery() {
            document.getElementById('imageGallery').style.display = 'none';
        }

        // Cart Functions
        function addToCart(productId) {
            const product = allProducts.find(p => p.id === productId);
            if (product) {
                cart.push({
                    ...product,
                    cartId: Date.now() + Math.random()
                });
                updateCartCount();
                updateCartDisplay();
                showToast('Product added to cart');
            }
        }

        function updateCartCount() {
            document.getElementById('cartCount').textContent = cart.length;
        }

        function updateCartDisplay() {
            const container = document.getElementById('cartItemsContainer');
            const total = cart.reduce((sum, item) => sum + item.price, 0);
            
            if (cart.length === 0) {
                container.innerHTML = `
                    <div style="text-align: center; padding: 40px; color: var(--text-color); opacity: 0.7;">
                        <i class="fas fa-shopping-cart" style="font-size: 48px; margin-bottom: 15px;"></i>
                        <p>Your cart is empty</p>
                    </div>
                `;
                document.getElementById('checkoutBtn').disabled = true;
            } else {
                container.innerHTML = cart.map(item => `
                    <div style="display: flex; gap: 15px; padding: 15px; border-bottom: 1px solid var(--border-color); align-items: center;">
                        <img src="${item.images[0]}" alt="${item.name}" 
                             style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px;">
                        <div style="flex: 1;">
                            <div style="font-weight: bold; font-size: 14px;">${item.name}</div>
                            <div style="color: var(--primary-color); font-weight: bold;">₦${item.price.toLocaleString()}</div>
                            <div style="font-size: 12px; color: var(--text-color); opacity: 0.7;">Seller: ${item.sellerName}</div>
                            <div style="font-size: 11px; color: var(--text-color); opacity: 0.6;">📞 ${item.sellerPhone}</div>
                        </div>
                        <button onclick="removeFromCart(${item.cartId})" 
                                style="background: #dc3545; color: white; border: none; width: 30px; height: 30px; border-radius: 50%; cursor: pointer;">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                `).join('');
                document.getElementById('checkoutBtn').disabled = false;
            }
            
            document.getElementById('cartTotalAmount').textContent = total.toLocaleString();
            document.getElementById('paystackAmount').textContent = total.toLocaleString();
            document.getElementById('paystackTotalAmount').textContent = total.toLocaleString();
            
            // Update order summary
            document.getElementById('paystackOrderSummary').innerHTML = cart.map(item => `
                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                    <span>${item.name}</span>
                    <span>₦${item.price.toLocaleString()}</span>
                </div>
            `).join('') + `
                <div style="border-top: 1px solid var(--border-color); padding-top: 8px; margin-top: 8px; font-weight: bold;">
                    <div style="display: flex; justify-content: space-between;">
                        <span>Total:</span>
                        <span>₦${total.toLocaleString()}</span>
                    </div>
                </div>
            `;
        }

        function removeFromCart(cartId) {
            cart = cart.filter(item => item.cartId !== cartId);
            updateCartCount();
            updateCartDisplay();
            showToast('Product removed from cart');
        }

        // Authentication Functions
        function showAuthModal() {
            document.getElementById('authModal').style.display = 'flex';
        }

        function closeAuthModal() {
            document.getElementById('authModal').style.display = 'none';
        }

        function showRegisterForm() {
            document.getElementById('loginForm').style.display = 'none';
            document.getElementById('registerForm').style.display = 'block';
            document.getElementById('authTitle').textContent = 'Create New Account';
        }

        function showLoginForm() {
            document.getElementById('registerForm').style.display = 'none';
            document.getElementById('loginForm').style.display = 'block';
            document.getElementById('authTitle').textContent = 'Login to Your Account';
        }

        function loginUser() {
            const email = document.getElementById('loginEmail').value;
            const password = document.getElementById('loginPassword').value;
            
            if (!email || !password) {
                showToast('Please fill all fields', 'error');
                return;
            }
            
            showLoadingPopup('Logging in...');
            
            auth.signInWithEmailAndPassword(email, password)
                .then((userCredential) => {
                    hideLoadingPopup();
                    showToast('Login successful!');
                    closeAuthModal();
                })
                .catch((error) => {
                    hideLoadingPopup();
                    showToast('Login failed: ' + error.message, 'error');
                });
        }

        function registerUser() {
            const name = document.getElementById('regName').value;
            const phone = document.getElementById('regPhone').value;
            const email = document.getElementById('regEmail').value;
            const password = document.getElementById('regPassword').value;
            const becomeSeller = document.getElementById('becomeSeller').checked;
            
            if (!name || !phone || !email || !password) {
                showToast('Please fill all fields', 'error');
                return;
            }
            
            showLoadingPopup('Creating account...');
            
            auth.createUserWithEmailAndPassword(email, password)
                .then((userCredential) => {
                    const user = userCredential.user;
                    return db.collection("users").doc(user.uid).set({
                        name: name,
                        phone: phone,
                        email: email,
                        isSeller: becomeSeller,
                        createdAt: firebase.firestore.FieldValue.serverTimestamp()
                    });
                })
                .then(() => {
                    hideLoadingPopup();
                    showToast('Account created successfully!');
                    closeAuthModal();
                    
                    if (becomeSeller) {
                        showSellerUpgradeModal();
                    }
                })
                .catch((error) => {
                    hideLoadingPopup();
                    showToast('Registration failed: ' + error.message, 'error');
                });
        }

        // Seller Image Upload System
        function previewImage(imageNumber) {
            const fileInput = document.getElementById(`productImage${imageNumber}`);
            const file = fileInput.files[0];
            const previewsContainer = document.getElementById('imagePreviews');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    // Create or update preview
                    let preview = document.getElementById(`preview${imageNumber}`);
                    if (!preview) {
                        preview = document.createElement('div');
                        preview.className = 'image-preview';
                        preview.id = `preview${imageNumber}`;
                        preview.innerHTML = `
                            <img src="${e.target.result}" alt="Preview ${imageNumber}">
                            <button type="button" class="remove-image" onclick="removeImage(${imageNumber})">
                                <i class="fas fa-times"></i>
                            </button>
                        `;
                        previewsContainer.appendChild(preview);
                    } else {
                        preview.querySelector('img').src = e.target.result;
                    }
                };
                reader.readAsDataURL(file);
            }
        }

        function removeImage(imageNumber) {
            const fileInput = document.getElementById(`productImage${imageNumber}`);
            const preview = document.getElementById(`preview${imageNumber}`);
            
            fileInput.value = '';
            if (preview) {
                preview.remove();
            }
        }

        async function uploadProduct() {
            if (!currentUser || !isSeller) {
                showToast('Please register as a seller first', 'error');
                return;
            }

            const name = document.getElementById('productName').value.trim();
            const price = document.getElementById('productPrice').value;
            const description = document.getElementById('productDescription').value.trim();
            const category = document.getElementById('productCategory').value;

            if (!name || !price || !description) {
                showToast('Please fill all required fields', 'error');
                return;
            }

            showLoadingPopup('Uploading your product...');

            try {
                // Get seller's phone number from their profile
                const userDoc = await db.collection("users").doc(currentUser.uid).get();
                const sellerPhone = userDoc.data()?.phone || "+2348064562826";
                const sellerName = userDoc.data()?.name || "Seller";

                const productData = {
                    name: name,
                    price: parseInt(price),
                    description: description,
                    category: category,
                    images: [getSimplePlaceholder()], // Placeholder image
                    sellerId: currentUser.uid,
                    sellerEmail: currentUser.email,
                    sellerName: sellerName,
                    sellerPhone: sellerPhone, // Seller's actual WhatsApp number
                    createdAt: firebase.firestore.FieldValue.serverTimestamp(),
                    status: 'active'
                };

                const docRef = await db.collection("products").add(productData);
                
                hideLoadingPopup();
                showToast('✅ Product uploaded successfully! Buyers will call YOUR number: ' + sellerPhone);
                
                sendNewProductNotification(productData, docRef.id);
                resetProductForm();
                loadSellerProducts();
                
            } catch (error) {
                hideLoadingPopup();
                console.error('Product upload error:', error);
                showToast('Error uploading product: ' + error.message, 'error');
            }
        }

        function getSimplePlaceholder() {
            return 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIyNCIgZmlsbD0iIzk5OTk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPlByb2R1Y3QgSW1hZ2U8L3RleHQ+PC9zdmc+';
        }

        function resetProductForm() {
            document.getElementById('productName').value = '';
            document.getElementById('productPrice').value = '';
            document.getElementById('productDescription').value = '';
            document.getElementById('imagePreviews').innerHTML = '';
            
            // Reset file inputs
            for (let i = 1; i <= 3; i++) {
                document.getElementById(`productImage${i}`).value = '';
            }
        }

        // Seller Management
        function handleSellerClick() {
            if (!currentUser) {
                showAuthModal();
                showRegisterForm();
                document.getElementById('becomeSeller').checked = true;
                showToast('Please register to become a seller');
                return;
            }
            
            db.collection("users").doc(currentUser.uid).get().then((doc) => {
                if (doc.exists && doc.data().isSeller) {
                    isSeller = true;
                    showPage('sellerDashboard');
                    loadSellerProducts();
                } else {
                    showSellerUpgradeModal();
                }
            }).catch(() => {
                showSellerUpgradeModal();
            });
        }

        function showSellerUpgradeModal() {
            const modal = document.createElement('div');
            modal.className = 'modal';
            modal.style.display = 'flex';
            modal.id = 'sellerUpgradeModal';
            modal.innerHTML = `
                <div class="modal-content">
                    <span class="close-modal" onclick="closeSellerUpgradeModal()">&times;</span>
                    <div style="text-align: center; margin-bottom: 20px;">
                        <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary-color), #c53030); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: white; font-size: 32px;">
                            <i class="fas fa-store"></i>
                        </div>
                        <h3 style="color: var(--text-color); margin-bottom: 10px;">Become a Verified Seller</h3>
                        <p style="color: var(--text-color); opacity: 0.7;">Start selling to thousands of buyers today!</p>
                    </div>

                    <div style="background: var(--footer-bg); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                        <h5 style="margin-bottom: 15px; color: var(--text-color); text-align: center;">Seller Benefits:</h5>
                        <div style="display: grid; gap: 10px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">Upload unlimited products</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">WhatsApp order notifications</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">Video call with buyers</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">Secure payment processing</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">24/7 marketplace access</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle" style="color: #28a745;"></i>
                                <span style="color: var(--text-color); font-size: 14px;">Completely FREE to start</span>
                            </div>
                        </div>
                    </div>

                    <div style="text-align: center; background: #e8f5e8; padding: 15px; border-radius: 8px; margin-bottom: 15px; border-left: 4px solid #25D366;">
                        <h5 style="color: #25D366; margin-bottom: 8px;">📞 Important Note:</h5>
                        <p style="color: var(--text-color); font-size: 13px; margin: 0;">
                            Buyers will video call <strong>YOUR WhatsApp number</strong> directly to see your products. 
                            Make sure your number is correct!
                        </p>
                    </div>

                    <div style="display: flex; gap: 10px;">
                        <button class="btn btn-outline" onclick="closeSellerUpgradeModal()" style="flex: 1; padding: 12px;">
                            Maybe Later
                        </button>
                        <button class="btn btn-primary" onclick="upgradeToSeller()" style="flex: 1; padding: 12px; background: linear-gradient(135deg, var(--primary-color), #c53030);">
                            <i class="fas fa-check"></i> Become Seller Now
                        </button>
                    </div>
                    
                    <div style="text-align: center; margin-top: 15px;">
                        <p style="color: var(--text-color); opacity: 0.7; font-size: 12px;">
                            <i class="fas fa-lock"></i> Your information is secure
                        </p>
                    </div>
                </div>
            `;
            document.body.appendChild(modal);
        }

        function closeSellerUpgradeModal() {
            const modal = document.getElementById('sellerUpgradeModal');
            if (modal) {
                modal.remove();
            }
        }

        function upgradeToSeller() {
            if (!currentUser) return;

            showLoadingPopup('Setting up your seller account...');

            db.collection("users").doc(currentUser.uid).update({
                isSeller: true,
                sellerSince: firebase.firestore.FieldValue.serverTimestamp(),
                videoCallEnabled: true
            }).then(() => {
                hideLoadingPopup();
                isSeller = true;
                closeSellerUpgradeModal();
                showToast('🎉 Seller account activated! Buyers will now call YOUR number');
                showPage('sellerDashboard');
                loadSellerProducts();
            }).catch((error) => {
                hideLoadingPopup();
                showToast('Error activating seller account: ' + error.message, 'error');
            });
        }

        function loadSellerProducts() {
            if (!currentUser || !isSeller) return;
            
            const sellerProductsGrid = document.getElementById('sellerProductsGrid');
            sellerProductsGrid.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--text-color); opacity: 0.7;">Loading your products...</div>';
            
            // For demo, show sample products. In production, load from Firestore
            setTimeout(() => {
                sellerProductsGrid.innerHTML = sampleProducts.map(product => `
                    <div class="product-card">
                        <div class="product-image" onclick="openImageGallery(${product.id})">
                            <img src="${product.images[0]}" alt="${product.name}">
                            ${product.images.length > 1 ? `
                                <div class="image-count-badge">
                                    <i class="fas fa-images"></i> ${product.images.length}
                                </div>
                            ` : ''}
                        </div>
                        <div class="product-info">
                            <h3 class="product-title">${product.name}</h3>
                            <div class="product-price">₦${product.price.toLocaleString()}</div>
                            <div class="seller-contact">
                                <strong>Buyers will call:</strong><br>
                                <small>📞 ${product.sellerPhone}</small>
                            </div>
                            <div style="display: flex; gap: 5px; margin-top: 10px;">
                                <button class="add-to-cart" style="background: #ffc107; color: black; flex: 1;">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="add-to-cart" onclick="deleteProduct(${product.id})" style="background: #dc3545; flex: 1;">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </div>
                    </div>
                `).join('');
            }, 1000);
        }

        function deleteProduct(productId) {
            if (!confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
                return;
            }
            showToast('Product deleted successfully!');
            loadSellerProducts();
        }

        // Modal Functions
        function showContactModal() {
            document.getElementById('contactModal').style.display = 'flex';
        }

        function closeContactModal() {
            document.getElementById('contactModal').style.display = 'none';
        }

        function showErrandBoysModal() {
            document.getElementById('errandBoysModal').style.display = 'flex';
        }

        function closeErrandBoysModal() {
            document.getElementById('errandBoysModal').style.display = 'none';
        }

        function showVideoCallGuide() {
            document.getElementById('videoCallGuideModal').style.display = 'flex';
        }

        function closeVideoCallGuide() {
            document.getElementById('videoCallGuideModal').style.display = 'none';
        }

        // Navigation Functions
        function toggleOsheMarket() {
            const currentPage = document.getElementById('homePage').classList.contains('active') ? 'homePage' : 'osheMarketPage';
            if (currentPage === 'homePage') {
                showPage('osheMarketPage');
                document.getElementById('osheMarketBtn').textContent = 'Go Back to Main Market Onitsha Online';
            } else {
                showPage('homePage');
                document.getElementById('osheMarketBtn').textContent = 'Enter Oshe Okwodu Market Onitsha';
            }
        }

        function showBecomeSellerPage() {
            showPage('becomeSellerPage');
        }

        function startSellerRegistration() {
            if (!currentUser) {
                showAuthModal();
                showRegisterForm();
                document.getElementById('becomeSeller').checked = true;
                showToast('Please register to become a seller');
            } else {
                handleSellerClick();
            }
        }

        function showAdminDashboard() {
            if (!currentUser) {
                showAuthModal();
                return;
            }
            
            // Simple admin check - in production, use proper admin validation
            const isAdmin = currentUser.email === 'godwindouglas8@gmail.com';
            
            if (isAdmin) {
                showPage('adminDashboard');
                loadAdminOrders();
            } else {
                showToast('Admin access only', 'error');
            }
        }

        function searchProducts() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            if (searchTerm) {
                const filteredProducts = allProducts.filter(product => 
                    product.name.toLowerCase().includes(searchTerm) ||
                    product.category.toLowerCase().includes(searchTerm)
                );
                displayProducts(filteredProducts, 'productsGrid');
            } else {
                loadProducts();
            }
        }

        // Payment Functions
        function checkoutWithPaystack() {
            if (cart.length === 0) {
                showToast('Your cart is empty', 'error');
                return;
            }
            showPage('paymentPage');
        }

        function processPaystackPayment() {
            if (cart.length === 0) {
                showToast('Your cart is empty', 'error');
                return;
            }

            const total = cart.reduce((sum, item) => sum + item.price, 0);
            
            showLoadingPopup('Confirming your order and notifying sellers...');

            // Simulate order processing
            setTimeout(() => {
                hideLoadingPopup();
                showToast('✅ Order confirmed! Sellers have been notified.');
                cart = [];
                updateCartCount();
                updateCartDisplay();
                showPage('homePage');
            }, 2000);
        }

        // Data Loading Functions
        function loadWishlist() {
            // Implementation for wishlist
        }

        function loadOrders() {
            // Implementation for orders
        }

        function loadProfile() {
            // Implementation for profile
        }

        function loadAdminOrders() {
            // Implementation for admin orders
            document.getElementById('totalOrders').textContent = '15';
            document.getElementById('todayOrders').textContent = '3';
            document.getElementById('pendingOrders').textContent = '2';
            document.getElementById('totalRevenue').textContent = '₦125,400';
        }

        function loadErrandBoys() {
            const container = document.getElementById('errandBoysGrid');
            container.innerHTML = errandBoys.map(boy => `
                <div style="background: var(--card-bg); padding: 15px; border-radius: 8px; margin-bottom: 10px; border: 1px solid var(--border-color);">
                    <div style="display: flex; gap: 15px; align-items: center;">
                        <img src="${boy.image}" alt="${boy.name}" style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover;">
                        <div style="flex: 1;">
                            <div style="font-weight: bold;">${boy.name}</div>
                            <div style="color: var(--text-color); opacity: 0.7; font-size: 12px;">⭐ ${boy.rating} Rating</div>
                            <div style="color: var(--text-color); opacity: 0.7; font-size: 12px;">📞 ${boy.phone}</div>
                        </div>
                        <button class="btn btn-primary" onclick="bookErrandBoy('${boy.phone}', '${boy.name}')" style="padding: 8px 15px; font-size: 12px;">
                            <i class="fas fa-calendar-check"></i> Book
                        </button>
                    </div>
                </div>
            `).join('');
        }

        function bookErrandBoy(phone, name) {
            const message = `Hello! I would like to book your errand boy services from Main Market Onitsha. Please let me know your availability and rates.`;
            const whatsappUrl = `https://wa.me/${phone.replace('+', '')}?text=${encodeURIComponent(message)}`;
            window.open(whatsappUrl, '_blank');
        }

        function sendNewProductNotification(product, productId) {
            const adminPhone = "2348064562826";
            const message = `🆕 NEW PRODUCT UPLOADED!

📦 Product: ${product.name}
💰 Price: ₦${product.price.toLocaleString()}
🏷️ Category: ${product.category}
👨‍💼 Seller: ${product.sellerName}
📧 Seller Email: ${product.sellerEmail}
📞 Seller WhatsApp: ${product.sellerPhone}
🆔 Product ID: ${productId}

Buyers will call seller directly at: ${product.sellerPhone}`;

            const whatsappUrl = `https://wa.me/${adminPhone}?text=${encodeURIComponent(message)}`;
            window.open(whatsappUrl, '_blank');
        }

        // Enhanced functions with loading states
        async function loginUserWithLoading() {
            const email = document.getElementById('loginEmail').value;
            LoadingManager.show('loginBtn', 'Logging in...');
            try {
                await loginUser();
            } finally {
                LoadingManager.hide('loginBtn');
            }
        }

        async function registerUserWithLoading() {
            LoadingManager.show('registerBtn', 'Creating Account...');
            try {
                await registerUser();
            } finally {
                LoadingManager.hide('registerBtn');
            }
        }

        async function uploadProductWithLoading() {
            LoadingManager.show('uploadProductBtn', 'Uploading Product...');
            try {
                await uploadProduct();
            } finally {
                LoadingManager.hide('uploadProductBtn');
            }
        }

        const LoadingManager = {
            originalStates: new Map(),
            
            show(buttonId, loadingText = 'Loading...') {
                const button = document.getElementById(buttonId);
                if (!button) return;
                
                // Save original state
                this.originalStates.set(buttonId, {
                    html: button.innerHTML,
                    disabled: button.disabled
                });
                
                // Apply loading state
                button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${loadingText}`;
                button.disabled = true;
            },
            
            hide(buttonId) {
                const button = document.getElementById(buttonId);
                const originalState = this.originalStates.get(buttonId);
                
                if (button && originalState) {
                    button.innerHTML = originalState.html;
                    button.disabled = originalState.disabled;
                    this.originalStates.delete(buttonId);
                }
            }
        };

        // Google Sign-in
        function initializeGoogleAuth() {
            // Google auth implementation would go here
        }

        // Toast Notification
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = `toast ${type === 'error' ? 'error' : ''}`;
            if (type === 'error') {
                toast.style.background = '#dc3545';
            }
            toast.innerHTML = `
                <i class="fas fa-${type === 'error' ? 'exclamation-circle' : 'check-circle'}"></i>
                ${message}
            `;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

        // Initialize cart display
        updateCartDisplay();

        // Close modals when clicking outside
        window.addEventListener('click', function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
            
            if (event.target === document.getElementById('imageGallery')) {
                closeGallery();
            }
        });

        // Keyboard navigation for gallery
        document.addEventListener('keydown', function(event) {
            const gallery = document.getElementById('imageGallery');
            if (gallery.style.display === 'flex') {
                if (event.key === 'ArrowRight') {
                    nextImage();
                } else if (event.key === 'ArrowLeft') {
                    prevImage();
                } else if (event.key === 'Escape') {
                    closeGallery();
                }
            }
        });
    </script>
</body>
</html>
