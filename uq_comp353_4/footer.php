<link rel="stylesheet" type="text/css" href="styles.css">
<footer style="text-align: center; padding: 20px; background: #f4f4f4; margin-top: 20px;">
    <p>Navigate Exercises:</p>
    <nav>
        <?php for ($i = 1; $i <= 23; $i++): ?>
            <a href="prj_<?php echo $i; ?>.php" style="margin: 5px; text-decoration: none; color: #007bff;">
                <?php echo $i; ?>. 
            </a>
        <?php endfor; ?>
    </nav>
    <p> &copy; <?php echo date('Y'); ?> COMP 353 Project </p>
</footer>
