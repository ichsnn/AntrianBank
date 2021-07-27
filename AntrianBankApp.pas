// Antrian Bank dengan Prioritas Menggunakan Heap (Min-Heap)
// Terdapat 2 Jenis Tabungan : Tabungan Bisnis; Tabungan Personal
// Tabungan Bisnis Memiliki Prioritas Lebih Tinggi

// Program Ini Menggunakan Array Sebagai Heap

program AntrianBankApp;
uses crt, MMsystem, sysUtils;

const
  MAX = 999;  // Maksimum Antrian

type
  NomorAntrian = record
    huruf : char;     // Jenis antrian : Bisnis(B); Personal(P)
    angka : integer;
  end;

  Antrian = record
    nomor : array[1..MAX] of NomorAntrian;
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

  // jika jenis antrian root dan anak kiri sama
  if qH.nomor[min].huruf = qH.nomor[L].huruf then
  begin
    // jika angka root lebih besar dari anak kiri
    if (L < size(qH)) and (qH.nomor[min].angka > qH.nomor[L].angka) then
      min := L;
  end
  // jika jenis antrian root dan anak kiri tidak sama
  else
  begin
    // jika huruf root (jenis) adalah P atau bukan prioritas
    if (L < size(qH)) and (qH.nomor[min].huruf = 'P') then
      min := L;
  end;

  // jika jenis antrian root dan anak kanan sama
  if qH.nomor[min].huruf = qH.nomor[R].huruf then
  begin
    // jika angka root lebih besar dari anak kanan
    if (R < size(qH)) and (qH.nomor[min].angka > qH.nomor[R].angka) then
      min := R;
  end
  // jika jenis antrian root dan anak kiri tidak sama
  else
  begin
    // jika huruf root (jenis) adalah P atau bukan prioritas
    if (R < size(qH)) and (qH.nomor[min].huruf = 'P') then
      min := R;
  end;

  // jika tidak sama dengan root
  if min <> N then
  begin
    // tukar nilai indeks
    swap(qH, N, min);
    // rekrusif shiftdown (prosedur yang sama)
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

  // jika huruf atau jenis sama
  if(qH.nomor[p].huruf = qH.nomor[c].huruf) then
    while (c > 0) and (qH.nomor[p].angka > qH.nomor[c].angka) do
    begin
      swap(qH, c, p);
      c := p;
      p := p div 2;
    end
  // jika huruf atau jenis tidak sama
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
  qH.size := qH.size + 1; // tambah size antrian

  // insert data di indeks paling bawah atau terakhir
  i := qH.size;
  qH.nomor[i].huruf := h;
  qH.nomor[i].angka := a;

  // lakukan shift up jika melanggar aturan heap
  shiftUp(qH, i);
end;

// tampilkan antrian (digunakan untuk cek isi keseluruhan antrian)
{
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
}

// dequeue atau extract-min
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
  // jika antrian kosong
  if (isEmpty(qH)) then
  begin
    gotoxy(wherex, wherey);write('Kosong');
  end
  // jika tidak
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
  begin
    gotoxy(wherex - 1, wherey);write('Kosong');
  end
  else
  begin
    // jika nomor antrian kurang dari 10 maka tampilan $huruf00$angka
    if m.angka < 10 then
      write(m.huruf,'00',m.angka)
    // jika nomor antrian kurang dari 100 maka tampilan $huruf0$angka
    else if m.angka < 100 then
      write(m.huruf,'0',m.angka)
    // jika nomor antrian kurang dari 100 maka tampilan $huruf$angka
    else
      write(m.huruf,m.angka);
  end;
end;

// putar suara
procedure playSound(suara : string);
var
  Pnamafile : PChar;
  namafile : string;
begin
  namafile := 'assets\sounds\' + suara + '.wav'; {directory file yang dipanggil}
  Pnamafile := StrAlloc(length(namafile));       {siapkan memori yang akan dipakai untuk menampung Pnamafile}
  Pnamafile := StrPCopy(Pnamafile, namafile);    {salin namafile ke Pnamafile}
  sndPlaySound(Pnamafile, snd_sync);             {putar suara sesuai nama file}
end;

// suara angka
procedure soundAngka(angka : int64);
begin
  // angka harus lebih dari 0
  // karena angka merupakan integer, maka lakukan konversi ke string menggunakan IntToStr() dengan unit sysUtils
  // untuk dikonversi menjadi string angka harus bertipe data setidaknya int64
  if angka > 0 then
  begin
    // jika angka kurang dari 10 suara "nol" "nol" "angka"
    if angka < 10 then
    begin
      playSound(IntToStr(0));
      playSound(IntToStr(0));
      playSound(IntToStr(angka));
    end
    // jika angka kurang dari 100 suara "nol" "satuan angka" "satuan sisa angka"
    else if angka < 100 then
    begin
      playSound(IntToStr(0));
      playSound(IntToStr(angka div 10));
      playSound(IntToStr(angka mod 10));
    end
    // jika angka kurang dari 1000 suara "satuan angka" "sisa satuan (satuan angka)" "sisa sisa (satuan angka)"
    else if angka < 1000 then
    begin
      playSound(IntToStr(angka div 100));
      playSound(IntToStr((angka mod 100) div 10));
      playSound(IntToStr((angka mod 100) mod 10));
    end;
  end;
end;

// suara ketika dilakukan pemanggilan
procedure soundPanggilan(jenis : char; angka : int64);
begin
  playSound('panggilan');
  playSound(jenis);
  soundAngka(angka);
  playSound('meja');
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
  // jika antrian tidak kosong lakukan pemanggilan (dequeue)
  if not isEmpty(qH) then
  begin
    m1 := dequeue(qH);
    // panggil prosedure suara ketika pemanggilan
    soundPanggilan(m1.huruf, m1.angka);
    // suara nomor meja
    playSound('1');
  end
  //jika antrian kosong tampilkan warning antrian kosong
  else
  begin
    writeln;
    gotoxy(2, wherey);
    TextBackground(4);
    TextColor(15);
    write('[Antrian Kosong!] Tekan tombol sembarang...   ');
    NormVideo;
    gotoxy(wherex - 3, wherey);
    readkey;
  end;
end;

// menu 4, panggil meja 2
procedure menu4(var qH : Antrian; var m2 : nomorAntrian);
begin
  //jika antrian tidak kosong lakukan pemanggilan (dequeue)
  if not isEmpty(qH) then
  begin
    m2 := dequeue(qH);
    // panggil prosedure suara ketika pemanggilan
    soundPanggilan(m2.huruf, m2.angka);
    // suara nomor meja
    playSound('2');
  end
  //jika antrian kosong tampilkan warning antrian kosong
  else
  begin
    writeln;
    gotoxy(2, wherey);
    TextBackground(4);
    TextColor(15);
    write('[Antrian Kosong!] Tekan tombol sembarang...   ');
    NormVideo;
    gotoxy(wherex - 3, wherey);
    readkey;
  end;
end;

// menu 5, keluar
procedure menu5();
begin
  writeln;
  gotoxy(2, wherey);
  TextBackground(15);
  TextColor(0);
  write('Terimakasih Telah Menggunakan Aplikasi Ini... ');
  NormVideo;
  gotoxy(wherex - 1, wherey);
  readkey;
end;

// menu, antrian, nomor antrian terakhir, nomor antrian di meja 1 dan 2
procedure pilihanMenu(menu : char; var qH : Antrian; var cur : integer; var m1 : nomorAntrian; var m2 : nomorAntrian);
begin
  case (menu) of
    '1' : menu1(qH, cur);
    '2' : menu2(qH, cur);
    '3' : menu3(qH, m1);
    '4' : menu4(qH, m2);
    '5' : menu5();
  else
    // jika inputan menu tidak sesuai
    writeln;
    gotoxy(2, wherey);
    TextBackground(4);
    TextColor(15);
    write('[Masukkan Salah!] Tekan tombol sembarang...   ');
    NormVideo;
    gotoxy(wherex - 3, wherey);
    readkey;
  end;
end;

// Deklarasi Variabel Yang Akan Digunakan
var
  q : Antrian;  {antrian bank}
  last : integer; {nomor antrian angka terakhir}
  menu : char; {pilihan menu}
  meja1, meja2 : nomorAntrian; {penampung nomor antrian yang dipanggi}

// PROGRAM UTAMA
begin
  init(q); {inisialisasi antrian atau array}
  meja1.huruf := ' '; {inisialisasi nomor antrian meja 1}
  meja1.angka := 0;
  meja2.huruf := ' '; {inisialisasi nomor antrian meja 2}
  meja2.angka := 0;
  last := 0; {inisialisasi nomor urutan angka terakhir}

  // Menu Utama
  repeat
    clrscr;
    //Tampilan Layar Program
    gotoxy(2, wherey);
    TextBackground(1);
    TextColor(15);
    writeln('                 SEBUAH BANK.                 ');
    normVideo;
    writeln;
    gotoxy(2, wherey);
    writeln('.--------------------------------------------.');
    gotoxy(2, wherey);
    writeln('|              |              |    Nomor     |');
    gotoxy(2, wherey);
    writeln('|    Meja 1    |    Meja 2    | Selanjutnya  |');
    gotoxy(2, wherey);
    writeln('|--------------|--------------|--------------|');
    gotoxy(2, wherey);
    write('|');
    gotoxy(8, wherey);
    displayMeja(meja1); {tampilkan nomor antrian di meja 1}
    gotoxy(17, wherey);
    write('|');
    gotoxy(23, wherey);
    displayMeja(meja2); {tampilkan nomor antrian di meja 2}
    gotoxy(32, wherey);
    write('|');
    gotoxy(37, wherey);
    peek(q);            {tampilkan nomor antrian selanjutnya}
    gotoxy(47,wherey);
    writeln('|');
    gotoxy(2, wherey);
    writeln('''--------------------------------------------''');
    writeln;
    gotoxy(2, wherey);

    {Pilihan Menu Program}
    gotoxy(2, wherey);
    writeln('-------------------- MENU --------------------');
    normVideo;
    writeln;
    gotoxy(2, wherey);
    writeln('1. Tambah Antrian Bisnis');
    gotoxy(2, wherey);
    writeln('2. Tambah Antrian Personal');
    gotoxy(2, wherey);
    writeln('3. Meja 1 Memanggil');
    gotoxy(2, wherey);
    writeln('4. Meja 2 Memanggil');
    gotoxy(2, wherey);
    writeln('5. Keluar');
    writeln;
    gotoxy(wherex + 1, wherey + 2);
    TextBackground(1);
    writeln('==============================================');
    normVideo;
    gotoxy(wherex + 1, wherey - 4);

    // inputan atau masukan pilihan menu
    write('Masukkan Pilihan (1-5) : ');readln(menu);

    // panggil prosedure pilihan menu
    pilihanMenu(menu, q, last, meja1, meja2);
  until menu = '5';
  clrscr;
end.
