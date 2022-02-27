# Skrypty bash !

W tym repozytorium znajdują się pliki  reprezentujące skrypty powłoki bash.   Skrypty powstały w celu usprawnienia i automatyzacji powtarzających się  czynności w codziennej pracy.  Do ich cyklicznego uruchamiania użyty został program cron,      

## Skrypt  backup_databases
Służy do  cyklicznego tworzenia kopi zapasowych wskazanych baz danych.    Do uruchomienia i przekazania bieżącej  daty służy backup_databases_wrapper.  W   backup_databases  tworzone są odpowiednie ścieżki do zapisania plików.  Użyte zostały narzędzia postgresa takie jak pg_dump do połączenie z bazą  a następnie do utworzenia kopi zapasowej odpowiednich schematów z wybranymi opcjami. Każde polecenie jest sprawdzane,  czy nie zwraca kodu błędu.
## Skrypt  update_DB_VMtest2

Służy do  cyklicznego wgrywania aktualizacji  do  wskazanych baz danych.    Do uruchomienia i przekazania bieżącej  daty służy update_DB_VMtest2_wrap.  W   update_DB_VMtest2  tworzone jest  połączenie z bazą danych, która będzie zaktualizowana.  Nawiązywane jest połączenie ze zdalnym serwerem za pomocą sshfs klienta systemu plików umożliwiającym montowanie i operowanie na katalogach i plikach. Następnie wydawany jest szereg poleceń  odnoszących się do bazy danych np.: usunięcie uprawnień dostępu połączenia z bazą danych dla każdej z ról, rozłączenie istniejących połączeń z bazą oprócz obecnego.  Przy wgrywaniu każdego schematu sprawdzane są komunikaty o błędach. Dodatkowo wszystkie logi ze skryptu zapisywane są do pliku tekstowego. 

## Skrypt  configure_panel

Skrypt ten służy do komunikacji z pracującym kontenerem dockera.  Aplikacja znajdująca się w kontenerze to program napisany w frameworku Laravel (PHP).  Skrypt ma zadeklarowane zmienne z poleceniami obsługiwanymi przez   dockera i aplikacje. Dodatkowo w skrypcie zaprogramowane jest odświeżanie zmaterializowanych widoków dla wskazanej bazy.   Następnie wykonywany jest szereg poleceń takich jak przykładowo wykonanie   migracji  aplikacji Laravel.  Ostatnimi funkcjonalnościami wykonywanymi w skrypcie jest podmienianie wskazanych plików w kontenerze aplikacji. 
