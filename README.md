<h1 align="center">
    <img src="./.github/Haeri.svg">
</h1>

<p align="center">
  <i align="center">ჰაერის ხარისხი მნიშვნელოვანია!</i>
</p>

<h4 align="center">
    <img src="https://camo.githubusercontent.com/e4ce55d770fef5d0e06360c75a2b6ae9a7389b465b4670303d5d4ee7261e6e48/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d31372e362b2d626c7565" style="height: 20px;">
    <img src="https://camo.githubusercontent.com/4b234edeae8f328f1018a0045d5a6fe15a8cc4346befa2440cd92e79ee25f480/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f55492d5377696674554925323025324225323055494b69742d627269676874677265656e" style="height: 20px;">
   <img src="https://camo.githubusercontent.com/0cf2fadad5edf3d627634ad223359bec43840206c41d7d2419b59caf5d8671a5/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f4172636869746563747572652d4d56564d253230253743253230436f6f7264696e61746f722d626c61636b" style="height: 20px;"> 
  <br>
    <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Storage-yellow" style="height: 20px;">
    <img src="https://camo.githubusercontent.com/aa6e952e8cd39d372d2389e5727ea225d32001bf426331dfc80c436730849842/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f436f72654c6f636174696f6e2d4c6f636174696f6e2d626c756576696f6c6574" style="height: 20px;">
        <img src="https://img.shields.io/badge/Groq-AI-ff4f00?style=flat" style="height: 20px;">
    <img src="https://camo.githubusercontent.com/32464a8bae95ffdb8841988ce764ef91c68d65f300eabadfecf8d661970c3041/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f436f6e63757272656e63792d436f6d62696e652532302537432532304173796e6325324641776169742d7465616c" style="height: 20px;">
</h4>

<p align="center">
    <img src="./.github/poster.png" alt="haeri poster"/>
</p>

## შესავალი

`Haeri` არის აპლიკაცია, რომელიც გვაწვდის ინფორმაციას ჰაერის დაბინძურების შესახებ და გვაძლევს პერსონალიზებულ რჩევებს ჩვენი ჯანმრთელობის დასაცავად.

აპლიკაციიდან მომხმარებელი არა მხოლოდ იღებს ინფორმაციას ჟანგბადის ხარისხის შესახებ, არამედ, ეცნობა თუ რა გავლენა ჰაერში არსებულ ნივთიერებებს ადამიანის ჯანმრთელობაზე.

აპლიკაციის ძირითად სამიზნე აუდიტორიას წარმოადგენენ ორსულები, მშობლები, ხანში შესული ადამიანები, სპორცმენები, რესპირატორული დაავადებებების მქონე და გარე სივრცეში მომუშავე პირები, ასევე აქტივისტები და უბრალოდ ზოგადი ინფორმაციით დაინტერესებული მოქალაქეები. 

`Haeri`-ის მომხმარებლები AI მხარდაჭერის საშუალებით იღებენ მყისიერ, მნიშვნელოვან ინფორმაციას დაბინძურების საფრთხეებზე. ის აერთიანებენ
ადამიანებს, რომლებიიც ზრუნავენ საკუთარი და გარშემომყოფების ჯანმრთელობაზე.

<details open>
<summary>
 Features
</summary> <br />

<p align="center">
    <img width="49%" src="./.github/feature-01.png" alt="haeri feature"/>
&nbsp;
    <img width="49%" src="./.github/feature-02.png" alt="haeri feature"/>
</p>

<p align="center">
    <img width="49%" src="./.github/feature-03.png" alt="haeri feature"/>
&nbsp;
    <img width="49%" src="./.github/feature-04.png" alt="haeri feature"/>
</p> 

</details>


## დეველოპმენტი

აპლიკაცია აგებულია **SwiftUI**-ზე, თუმცა იმ ნაწილებში, სადაც საჭიროა უფრო დეტალური კონტროლი ან legacy კომპონენტები, გამოყენებულია **UIKit**.

<details open>
<summary><strong>🛠 ტექნიკური სტეკი</strong></summary>

#### 📱 iOS
- **Swift** — SwiftUI & UIKit
- **Combine** — state management და async ნაკადები
- **CoreLocation** — ლოკაციის მონაცემების დამუშავება

#### ☁️ Backend / Services
- **Firebase** — authentication, მონაცემების შენახვა და სერვისები

#### 🌐 External APIs
- **Groq API** — AI რეკომენდაციები
- **OpenWeather API** — ამინდის მონაცემები

</details>

<details open>
<summary><strong>🏗 არქიტექტურა</strong></summary>

- **MVVM + Coordinator** — პასუხისმგებლობების მკაფიო დაყოფა და ნავიგაციის იზოლაცია  
- **Dependency Injection** — ტესტირებადობა და მოქნილი მოდულარობა

</details>

## მოთხოვნები
- Xcode 15+
- iOS 17.6 deployment target


## ინსტალაცია
1. დააკლონეთ რეპოზიტორი
2. გახსენით `Haeri.xcodeproj`
3. აირჩიეთ სიმულატორი
4. გაუშვით აპლიკაცია (⌘R)

