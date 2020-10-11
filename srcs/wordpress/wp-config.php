<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'admin' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '!}/MnxA0~YU|nQW}OnK}J%6=A=lr~zJuz${GV4FpkW1r+WGcUm*jCsqRYy<~54VQ' );
define( 'SECURE_AUTH_KEY',  '})Hbj<i[>pDc[<F9ARnABHf:xJ?^T&52NTr}FZ>]}U?z7/:Xr0+Q2hsr@1uc9cU6' );
define( 'LOGGED_IN_KEY',    '7L[6hnJpw-W9{+#R$ZBbND3GGk)UC@NOI)Z17lnjKc_Jw1).gK;mAG&M#H,-<wyH' );
define( 'NONCE_KEY',        'h57f+#azUcpzp].QAI+nF=Nv$`bg3(O(37KRQ|$f`n$qK|nfw39,$xk9pYPnfy4n' );
define( 'AUTH_SALT',        'PZ+x9F,DN Lxa`f`jiHfk3IO;[udG2UI]`Wob;f~|{YBxF0q*LAyAAwF~i=5bySN' );
define( 'SECURE_AUTH_SALT', 'Tb-z<4brpD(RWT$r/kJd Xa)hGE)wt|*ZVRnC%.X7_XX9S2ax2:tJf<xT^v:n>j}' );
define( 'LOGGED_IN_SALT',   '$u?pxI oUtArzTzbA>OZ4/=1vl`L!y<&b{>u+:%),0kJ0~P&&S3XSFHS9f^##:9d' );
define( 'NONCE_SALT',       ';)tI=]<ut]mr]3b*Wa(CAW5S3W5>Fn96Z;+n|3J7]~wKO `ev.r!RV$V^B#}i$(Y' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
