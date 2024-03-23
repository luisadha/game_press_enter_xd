#!/usr/bin/env bash
# set -x
version="v1.0.1"
status=0
function usage() {
  echo -e "Available options:"
  echo -e ""
  echo -e "     help" "   Print this help messages."
  echo -e "     save" "   Give your name for score."
  echo -e "     score" "  Print score from last game."
  echo -e "     reset" "  Reset score from last game."
  echo -e "     news" "   See update/changelog for this script."
  echo -e "     version" "Print script version."
  echo 
  exit ${status:-1}
}

set +o noclobber
cat <<- "EOF" > $0.intructions

# Copy kode dibawah ini lalu paste ke .bashrc / .bash_profile anda
#
: '
export PATH="$PATH:/system/bin"
alias r='fc -e -'
'
# Cara main
# 1. Setelah anda berhasil buat alias tadi
# 2. bash ./game_press_enter_xd.sh 
# 3. Ketik huruf r sebelum script ini menekan tombol enter dengan sendirinya.
# 4. Lalu lakukan sebanyak mungkin sampai looping berhenti
#    !! Ingat tidak terlalu cepat tidak terlalu lambat
# 5. Jika prompt anda tertulis huruf rr MAKA artinya anda game berakhir (GAME OVER) karena loopingnya juga berhenti
# 6. Hitung skor: Hitunglah banyaknya huruf r tunggal di setiap prompt yang anda peroleh, contoh high score saya cuma sebanyak 4 (r) ditotal. harap diperhatikan rr tidak dihitung ke dalam skor.
# 7 Jika anda typo huruf selain r anda Kalah dan game juga berakhir
# 8. Jika anda menghitung r disetiap line tidak masalah anda harus membagi 2 misal r yang di temui di setiap line berjumlah 8 / 2 berarti Skor anda 4.
# 8. Jadilah sportif.
#
EOF

opt="$1"
if [ -z "$opt" ]; then


output_array=()
files_array=()


 mapfile -t files < <(find . -type f -iname 'game_press_enter_xd.sh.score.*')
   for file in "${files[@]}"; do
   files_array+=("$file")                                   
   output_array+=("$(nl -b a "$file" | wc -l)")
   done
  
   max_value=0
   max_index=-1
  for i in "${!output_array[@]}"; do
   if (( output_array[i] > max_value )); then               
     max_value="${output_array[i]}"
     max_index="$i"                                       
   fi
  done
  

 if (( max_index >= 0 )); then

  user="$(echo "${files_array[max_index]}" |awk -F. '{print (NF>1?$NF:"no extension")}')"
   else
  echo "Fail: no such file score!"
   fi

score=0
for count in "${output_array[@]}"; do
    if (( count > score )); then
        score="$count"
    fi
done

    currScore=$(nl -b a $0.score 2> /dev/null | wc -l )
   
finalScore=$((currScore - 1))
if [ $finalScore -lt 0 ]; then
    
    finalScore=0
fi

highRank=$(echo "$score - 1" | bc)

if [ ${highRank} -gt $finalScore  ]; then

  echo -e "Score tertinggi saat ini: $highRank ($user)"
   fi

     

echo "Your high score: $finalScore"

echo '💬Tekan r secepat mungkin sebelum bot menekan Enter:'

read -s -n 1 -d  $'\n' waitInput & echo $waitInput >> $0.score & input keyevent ENTER

echo  '👾(Ai): Telah menekan tombol Enter'

elif [ "$opt" == "reset" ]; then
echo '' > $0.score
echo "Skor berhasil direset!"
exit 0;
elif [ "$opt" == "score" ]; then
  echo -n "Skor terakhir anda: "
  test -f $0.score;

  if [ $? -eq 1 ]; then
    echo "0"
  else

    score=$(nl -b a $0.score | wc -l)
    result=$((score - 2))
    
    if [ $result -lt 0 ]; then
      result=0
    fi
    echo -e "${result} (unknown player)"
  fi

  echo "[!] Ingat selalu mereset Skor anda, sebelum memulai game ini lagi."
  exit 0;
elif [ "$opt" == "news" ]; then
  echo "(v1.0.0) : Rilis pertama belum dipublikasikan"
  echo "($version) : Fitur save skor segera hadir di versi akan datang! (current)"
  echo "(v1.0.2) : Fitur leaderboard segera hadir di versi yang akan datang!"
  exit 0
elif [ "$opt" == "save" ]; then
  echo -e "Masukan nama: "
  read name
  mv -i "$0.score" "$0.score.${name}"
  echo "Sukses menyimpan score!"
  exit 0
elif [ "$opt" == "help" ]; then
  
  cat $0.intructions
  echo
  usage
elif [ "$opt" == "version" ]; then
  echo "$0 (fun game)"
  echo "Version: $version"
  echo "Author: @space_button "
  exit 0;
else
  echo "Error: unknown option"
  echo
  usage 1
fi

