<?php
header('Content-Type: application/json');
include 'config.php';

// Ambil ID Pelanggan dari parameter (misal: get_orders.php?id_pelanggan=1)
$id_pelanggan = $_GET['id_pelanggan'];

// Query untuk mengambil data pesanan beserta nama kostumnya
$sql = "SELECT p.id_penyewaan, p.tgl_sewa, p.status, k.nama_kostum 
        FROM penyewaan p
        JOIN detail_penyewaan dp ON p.id_penyewaan = dp.id_penyewaan
        JOIN kostum k ON dp.id_kostum = k.id_kostum
        WHERE p.id_pelanggan = '$id_pelanggan'
        ORDER BY p.tgl_sewa DESC";

$result = mysqli_query($conn, $sql);
$orders = array();

if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {
        // Konversi status string dari DB ke integer index (0-4) untuk Flutter
        // Sesuaikan dengan nama status di database kamu
        $status_index = 0;
        switch ($row['status']) {
            case 'Menunggu Deposit': $status_index = 0; break;
            case 'Diproses':         $status_index = 1; break;
            case 'Aktif':            $status_index = 2; break;
            case 'Selesai':          $status_index = 3; break;
            case 'Batal':            $status_index = 4; break;
        }

        $orders[] = array(
            "orderId" => $row['id_penyewaan'],
            "costumeName" => $row['nama_kostum'],
            "date" => $row['tgl_sewa'],
            "statusIndex" => $status_index
        );
    }
    echo json_encode(["success" => true, "data" => $orders]);
} else {
    echo json_encode(["success" => false, "message" => "Belum ada pesanan"]);
}
?>