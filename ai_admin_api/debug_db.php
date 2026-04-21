<?php
$host = 'mysql-aeo';
$db   = 'aeo_ai';
$user = 'root';
$pass = 'root';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ATTR_ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
     
     $standardId = 6;
     $masterId = 2;
     
     echo "--- checking company info ---\n";
     $stmt = $pdo->prepare("SELECT bind_projects FROM company_info WHERE master_id = ?");
     $stmt->execute([$masterId]);
     $company = $stmt->fetch();
     $bindProjects = $company ? $company['bind_projects'] : '';
     echo "Bind Projects: $bindProjects\n";
     
     echo "--- checking fcf records for standard 6 ---\n";
     $stmt = $pdo->query("SELECT id, folder_id, folder_name FROM folder_check_files WHERE standard_id = 6");
     $fcfList = $stmt->fetchAll();
     echo "Total FCF: " . count($fcfList) . "\n";
     
     echo "--- checking Join ---\n";
     $bindIds = explode(',', $bindProjects);
     $placeholders = str_repeat('?,', count($bindIds) - 1) . '?';
     $sql = "SELECT fcf.id, fcf.folder_name, f.id as folder_id, f.name as physical_name 
             FROM folder_check_files fcf 
             JOIN folders f ON fcf.folder_id = f.id 
             WHERE fcf.standard_id = 6 AND fcf.id IN ($placeholders)";
     
     $stmt = $pdo->prepare($sql);
     $stmt->execute($bindIds);
     $results = $stmt->fetchAll();
     echo "Returned Projects (Joined): " . count($results) . "\n";
     
     if (count($results) == 0) {
         echo "DEBUG: Query returned zero results. Checking why...\n";
         // Check if folder_id matches any folder
         foreach ($fcfList as $item) {
             if (in_array($item['id'], $bindIds)) {
                 $f_stmt = $pdo->prepare("SELECT id, name FROM folders WHERE id = ?");
                 $f_stmt->execute([$item['folder_id']]);
                 $f = $f_stmt->fetch();
                 if (!$f) {
                     echo "MISSING FOLDER: fcf_id {$item['id']} points to folder_id {$item['folder_id']} which does NOT exist!\n";
                 } else {
                     echo "VALID FOLDER: fcf_id {$item['id']} is valid!\n";
                 }
             }
         }
     }

} catch (\PDOException $e) {
     throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
