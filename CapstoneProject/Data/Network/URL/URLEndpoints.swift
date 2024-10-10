//
//  UrlEndiponts.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 10.10.2024.
//

enum URLEndpoints: String {
    case fetchProducts = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
    case fetchImages = "http://kasimadalan.pe.hu/urunler/resimler/"
    case addToBasket = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
    case fectBasket = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
    case removeFromBasket = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
}
