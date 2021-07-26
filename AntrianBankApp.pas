// Antrian Bank dengan Prioritas Menggunakan Heap (Min-Heap)
// Terdapat 2 Jenis Tabungan : Tabungan Bisnis; Tabungan Personal
// Tabungan Bisnis Memiliki Prioritas Lebih Tinggi

// Program Ini Menggunakan Array Sebagai Heap

program AntrianBankApp;
uses crt;

const
  MAX = 100;  // Maksimum Antrian

type
  NomorAntrian = record
    huruf : char;     // Bisnis(B), Personal(P)
    angka : integer; 
  end;

  Antrian = record
    nomor : array[1..100] of NomorAntrian;
    size : integer;  // Banyak Antrian
  end;

// inisialisasi antrian
procedure init(var qH : Antrian);
var
  i : integer;
begin
  for i := 0 to MAX do
  begin
    qH.nomor[i].huruf := ' ';
    qH.nomor[i].angka := 0;
  end;
  qH.size := 0;
end;

// panjang antrian, qH adalah data masukan untuk antrian
function size(qH : Antrian) : integer;
begin
  size := qH.size;
end;

// cek antrian kosong
function isEmpty(qH : Antrian) : boolean;
begin
  isEmpty := qH.size = 0;
end;

// tukar nilai, a dan b adalah nilai indeks yang akan ditukar
procedure swap(var qH : Antrian; a : integer; b : integer);
var
  temp : NomorAntrian; // penampung nilai yang ditukar
begin
  temp := qH.nomor[a];
  qH.nomor[a] := qH.nomor[b];
  qH.nomor[b] := temp;
end;

// shift down (geser ke bawah), N adalah level elemen heap
procedure shiftDown(var qH : Antrian; N : integer);
var
  min : integer;
  L : integer;  // indeks anak kiri
  R : integer;  // indeks anak kanan
begin
  min := N;   // indeks root
  L := N * 2;
  R := N * 2 + 1;
  // jika anak kiri lebih besar dari root
  if qH.nomor[min].huruf = qH.nomor[L].huruf then
  begin
    if (L < size(qH)) and (qH.nomor[min].angka > qH.nomor[L].angka) then
      min := L;
  end
  else
  begin
    if (L < size(qH)) and (qH.nomor[min].huruf = 'P') then
      min := L;
  end;
  // jika anak kanan lebih besar dari root
  if qH.nomor[min].huruf = qH.nomor[R].huruf then
  begin
    if (R < size(qH)) and (qH.nomor[min].angka > qH.nomor[R].angka) then
      min := R;
  end
  else
  begin
    if (R < size(qH)) and (qH.nomor[min].huruf = 'P') then
      min := R;
  end;

  // jika tidak sama dengan root
  if min <> N then
  begin
    // tukar nilai indeks
    swap(qH, N, min);
    // rekrusif
    shiftDown(qH, min);
  end;
end;

// shift up (bubble, geser ke atas)
procedure shiftUp(var qH : Antrian; posisi : integer);
var
  p : integer;  // parent indeks
  c : integer;  // indeks sekarang atau child dari parent
begin
  p := posisi div 2;
  c := posisi;
  if(qH.nomor[p].huruf = qH.nomor[c].huruf) then
    while (c > 0) and (qH.nomor[p].angka > qH.nomor[c].angka) do
    begin
      swap(qH, c, p);
      c := p;
      p := p div 2;
    end
  else
    while (c > 0) and (qH.nomor[p].huruf = 'P') do
    begin
      swap(qH, c, p);
      c := p;
      p := p div 2;
    end;
end;

// tambah antrian, h adalah huruf dari nomor antrian, a adalah angka dari nomor antrian
procedure insert(var qH : Antrian; h : char; a : integer);
var
  i : integer;  // indeks
begin
  if qH.size = MAX then
    writeln('[Antrian Penuh]')
  else
  begin
    qH.size := qH.size + 1;
    i := qH.size;
    qH.nomor[i].huruf := h;
    qH.nomor[i].angka := a;
    shiftUp(qH, i);
  end;
end;

// tampilkan antrian
procedure display(qH : Antrian);
var
  i : integer;
begin
  write('Nomor Antrian :');
  if qH.size <= 0 then
    write(' [Antrian Kosong]')
  else
    for i := 1 to qH.size do
      write(' ' , qH.nomor[i].huruf , qH.nomor[i].angka);
  writeln;
end;


// dequeue
function dequeue(var qH : Antrian) : NomorAntrian;
var
  front : NomorAntrian;
begin
  front := qH.nomor[1];
  qH.nomor[1] := qH.nomor[qH.size];
  qH.nomor[qH.size].huruf := ' ';
  qH.nomor[qH.size].angka := 0;
  shiftDown(qH, 1);
  qH.size := qH.size - 1;
  dequeue := front;
end;

// lihat nomor selanjutnya yang akan dipanggil
procedure peek(qH : Antrian);
var
  temp : nomorAntrian;
begin
  if isEmpty(qH) then
    write('-')
  else
  begin
    temp := qH.nomor[1];
    if temp.angka < 10 then
      write(temp.huruf,'00',temp.angka)
    else if temp.angka < 100 then
      write(temp.huruf,'0',temp.angka)
    else
      write(temp.huruf,temp.angka);
   end;
end;

// tambah antrian bisnis. cur adalah urutan angka terakhir saat ini
procedure enqueueB(var qH : Antrian; cur : integer);
begin
  insert(qH, 'B', cur);
end;

// tambah antrian personal.
procedure enqueueP(var qH : Antrian; cur : integer);
begin
  insert(qH, 'P', cur);
end;

// tampilan panggilan meja1
procedure displayMeja(m : nomorAntrian);
begin
  if m.angka = 0 then
    write('-')
  else
  begin
    if m.angka < 10 then
      write(m.huruf,'00',m.angka)
    else if m.angka < 100 then
      write(m.huruf,'0',m.angka)
    else
      write(m.huruf,m.angka);
  end;
end;

// menu 1, tambah antrian bisnis
procedure menu1(var qH : Antrian; var cur : integer);
begin
  cur := cur + 1;
  enqueueB(qH, cur);
end;

// menu 2, tambah antrian personal
procedure menu2(var qH : Antrian; var cur : integer);
begin
  cur := cur + 1;
  enqueueP(qH, cur);
end;

// menu 3, panggil meja 1
procedure menu3(var qH : Antrian; var m1 : nomorAntrian);
begin
  if not isEmpty(qH) then
    m1 := dequeue(qH)
  else
  begin
    writeln;
    gotoxy(2, wherey);TextBackground(4);TextColor(15);write('[Antrian Kosong!] Tekan tombol sembarang...   ');
    NormVideo;
    gotoxy(wherex - 3, wherey);readkey;
  end;
end;

// menu 4, panggil meja 2
procedure menu4(var qH : Antrian; var m2 : nomorAntrian);
begin
  if not isEmpty(qH) then
    m2 := dequeue(qH)
  else
  begin
    writeln;
    gotoxy(2, wherey);TextBackground(4);TextColor(15);write('[Antrian Kosong!] Tekan tombol sembarang...   ');
    NormVideo;
    gotoxy(wherex - 3, wherey);readkey;
  end;
end;

// menu 5, keluar
procedure menu5();
begin
  writeln;
  gotoxy(2, wherey);TextBackground(15);TextColor(0);write('Terimakasih Telah Menggunakan Aplikasi Ini... ');
  gotoxy(wherex - 1, wherey);readkey;
end;

// menu, antrian, nomor antrian terakhir, nomor antrian di meja 1 dan 2
procedure pilihanMenu(menu : integer; var qH : Antrian; var cur : integer; var m1 : nomorAntrian; var m2 : nomorAntrian);
begin
  case (menu) of
    1 : menu1(qH, cur);
    2 : menu2(qH, cur);
    3 : menu3(qH, m1);
    4 : menu4(qH, m2);
    5 : menu5();
  end;
end;

var
  q : Antrian;  // antrian bank
  last : integer; // nomor antrian angka terakhir
  menu : integer; // pilihan menu
  meja1, meja2 : nomorAntrian; // penampung nomor antrian yang dipanggi

// PROGRAM UTAMA
begin
  init(q); // inisialisasi antrian atau array
  meja1 := q.nomor[1]; // inisialisasi nomor antrian meja 1
  meja2 := q.nomor[1]; // inisialisasi nomor antrian meja 2
  last := 0; // inisialisasi nomor urutan angka terakhir
  // Menu Utama
  repeat
    gotoxy(2, wherey);TextBackground(1);TextColor(15);
    writeln('                SEBUAH BANK.                 ');
    normVideo;
    writeln;
    gotoxy(2, wherey);writeln('.-------------------------------------------.');
    gotoxy(2, wherey);write('|');
    gotoxy(17, wherey);write('|');
    gotoxy(32, wherey);write('|');
    gotoxy(wherex, wherey);write('    Nomor     ');
    gotoxy(46,wherey);writeln('|');
    gotoxy(2, wherey);write('|');
    gotoxy(17, wherey);write('|');
    gotoxy(32, wherey);write('|');
    gotoxy(7, wherey);write('Meja 1');
    gotoxy(22, wherey);write('Meja 2');
    gotoxy(34, wherey);write('Selanjutnya');
    gotoxy(46, wherey);writeln('|');
    gotoxy(2, wherey);write('|');
    gotoxy(17, wherey);write('|');
    gotoxy(32, wherey);write('|');
    gotoxy(3, wherey);write('--------------');
    gotoxy(18, wherey);write('--------------');
    gotoxy(33, wherey);write('--------------');
    gotoxy(46, wherey);writeln('|');
    gotoxy(2, wherey);write('|');
    gotoxy(8, wherey);displayMeja(meja1);
    gotoxy(17, wherey);write('|');
    gotoxy(23, wherey);displayMeja(meja2);
    gotoxy(32, wherey);write('|');
    gotoxy(37, wherey);peek(q);
    gotoxy(46,wherey);writeln('|');
    gotoxy(2, wherey);writeln('''-------------------------------------------''');
    writeln;
    gotoxy(2, wherey);writeln('MENU');
    writeln;
    gotoxy(2, wherey);writeln('1. Tambah Antrian Bisnis');
    gotoxy(2, wherey);writeln('2. Tambah Antrian Personal');
    gotoxy(2, wherey);writeln('3. Meja 1 Memanggil');
    gotoxy(2, wherey);writeln('4. Meja 2 Memanggil');
    gotoxy(2, wherey);writeln('5. Keluar');
    writeln;
    gotoxy(wherex + 1, 20);TextBackground(1);writeln('==============================================');
    normVideo;
    gotoxy(wherex + 1, 17);write('Masukkan Pilihan (1-5) : ');readln(menu);
    pilihanMenu(menu, q, last, meja1, meja2);
    clrscr;
  until menu = 5;
end.
