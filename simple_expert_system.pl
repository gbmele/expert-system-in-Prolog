% +----------------------------------------------+
% | BATUHAN TOPALOĞLU 151044026 CSE341 HW3 PART1 |
% +----------------------------------------------+
%%%
%
% çalıştırma sırasında add method formatlarına bakılmak istenirse
% 'formats()' çağrılabilir.
%
%>>>>>>> conflicts(CourseID1,CourseID2):-
%      Burada kontrolün doğru dönebilmesi için arka planda
%     bu iki dersin ders saatlerinde çakışma olmuyor olması
%     gerekiyor.
%
%     ! Bence çakışma için sadece zaman çakışması olması yeterli,
%     sınıfların ayrı olması çakışma olmadığı anlamına gelmez.
%
%>>>>>>> assign(RoomID,CourseID):-
%
%     1- Sınıfta o dersin ders saati kadar boş bir saat dilimi olup
%       olmadığına bakılır.
%
%     2- Sınıfın ekipmanları dersin gereksinimlerini
%       karşılıyor mu o kontrol edilir.
%
%     3- Sınıfın öğrenci kapasitesi dersin kapasitesine uygun mu diye
%       konrol edilir. O an dersi alan öğrenci sayısına değil, direk
%       dersin kapasitesine göre kontrol ettim.
%
%
%>>>>>>> enroll(StudentID,CourseID):-
%
%     1- Dersin alındığı sınıfın imkanları engelli öğrencilere uygun mu
%       diye kontrol edilir.
%
%     2- Dersin öğrenci kapasitesi yeni öğrenci eklenmeye uygun mu diye
%       kontrol edilir.
%
%
%
%>>>>>>>> add_student(SID,Cours,Hc):-
%
%     1- Daha önce SID de bir öğrenci olup olmadığı kontrol edilir,
%        varsa işlem false olur.
%
%     2- Kayıt olanmak istenilen derslerin geçerli birer ders olup
%        olmadığı kontrol edilir.
%
%     3- Kayıt olunmak istenilen derslerin sınıfları öğrenci için uygun
%        koşullara sahip mi diye kontrol edilir.
%
%     4- Kayıt olunmak istenilen sınıfta boş kontenjan var mı diye
%        kontrol edilir.
%
%     5- Kayıt olunmak istenilen derslerin saatleri birbirleriyle
%     çakışıyor mu diye kontrol edilir.
%
%
%>>>>>>>> add_room(RID,Cap,Eq):-
%
%     1- sadece daha önce aynı ID ile bir sınıf olmaması yeterli koşul.
%
%
%>>>>>>>> add_course(CID,IID,C,HourList,R,E):-
%
%     1- aynı ID ile daha önce oluşturulmuş bir kurs var mı diye kontrol
%     edilir.
%
%     2- verilen instructor ID geçerli bir ID mi diye kontrol edilir.
%
%     3- occupancy tablosunu güncellemeyi kullanıcıya bıraktım.
%
% ** >>>>>>>> yeni kurs eklendiğinde occupancy tablosunun güncellemesi
% işini kullanıcı tarafına bırakıyorum ,güncelleme yapılmazsa
% hatalı sonuçlar ortaya çıkabilir. Bu bir eksik sayılabilir sanırım
% ancak bu kısmı yetiştiremedim diyebilirim. Diğer bütün kontrollerimin
% doğru çalıştığını düşünüyorum.
%
%


:-dynamic(room/3).
:-dynamic(instructor/3).
:-dynamic(student/3).
:-dynamic(course/6).
:-dynamic(occupancy/3).

%room(room_ID,Capacity,Equipment)
room(z06,10,[hcapped,projector]).
room(z11,15,[hcapped]).  % 10


%instructor(ınstructor_ID).
instructor(genc,[projector],[cse341]).
instructor(turker,[smartboard],[cse343]).
instructor(bayrakci,[],[cse331]).
instructor(gozupek,[smartboard],[cse321]).

%student(Student_ID,Cours_list,hcapped)
student(1,[cse341,cse343,cse331],no). % sizin verdiğiniz tabloda derslerin kapasitesi gözetilmeden bir atama yapılmış.
student(2,[cse341,cse343],no).        % bunlar program başlarken yüklü bilgi olarak geldiği için kontrol etmiyorum.
student(3,[cse341,cse331],no).
student(4,[cse341],no).
student(5,[cse343,cse331],no).
student(6,[cse341,cse343,cse331],yes).
student(7,[cse341,cse343],no).
student(8,[cse341,cse331],yes).
student(9,[cse341],no).
student(10,[cse341,cse321],no).
student(11,[cse341,cse321],no).
student(12,[cse343,cse321],no).
student(13,[cse343,cse321],no).
student(14,[cse343,cse321],no).
student(15,[cse343,cse321],yes).



%course(course_ID,ınstructor_ID,Capacity,Hour,Room,Needs)
course(cse341,genc,10,4,z06,[hcapped]).
course(cse343,turker,6,3,z11,[]).
course(cse331,bayrakci,5,3,z06,[]).
course(cse321,gozupek,10,4,z11,[]).

%occupancy(Room_ID,Hour,Cours_ID)
occupancy(z06,8,cse341).
occupancy(z06,9,cse341).
occupancy(z06,10,cse341).
occupancy(z06,11,cse341).
occupancy(z06,12,n).
occupancy(z06,13,cse331).
occupancy(z06,14,cse331).
occupancy(z06,15,cse331).
occupancy(z06,16,n).
occupancy(z11,8,cse343).
occupancy(z11,9,cse343).
occupancy(z11,10,cse343).
occupancy(z11,11,n).
occupancy(z11,12,n).
occupancy(z11,13,cse321).
occupancy(z11,14,cse321).
occupancy(z11,15,cse321).
occupancy(z11,16,cse321).


% çalıştırma sırasında method formatlarına bakılmak istenirse diye
% ekledim.
formats():-
   write('METHOD FORMATS :'),nl,
   write('add_student(Student_ID,[cseXXX,cseXXX,...],handicapped yes/no)'),nl,
   write('add_course(Course_ID,Instruction_ID,Capacity,Hour,Room_ID,Equipment)'),nl,
   write('add_room(Room_ID,Room_Capacity,Room_EquipmentsList)'),nl.


% Check whether there is any scheduling conflict. -->
conflict(CID1,CID2):-
    course_hour(8,CID1,[],C1),  %Kursların ders saatlerinde bir çakışma var mı diye kontrol edilir.
    course_hour(8,CID2,[],C2),  %Normal hayatta ders çakışması için sadece saatlere baktığımız için burada sınıfları kontrol etmiyorum.
    \+compare_lists(C1,C2).


% Check which room can be assigned to a given class. -->
assign(RoomID,CourseID):-
    course(CourseID,_,CC,CH,_,ELM),
    room(Room,RC,RE),
    RC >= CC,                        % kapasitesi yeterli mi diye kontrol edilir.
    include_lists(ELM,RE),           % ders için gerekli ekipmanların sınıfta olup olmadığı kontrol edilir.
    free_time(8,Room,0,CH),          % sınıfta ders için yeterli boş saat var mı diye kontrol edilir.
    RoomID  =  Room.


% Check whether a student can be enrolled to a given class. -->
enroll(StudentID,CourseID):-

    student(StudentID,_,H),
    course(CourseID,_,Capacity,_,Roomm,_),
    room(Roomm,_,Req),
    (H == yes, HK = hcapped ,include_lists([HK],Req); H == no),
    course_counterr(CourseID,Res),
    Res < Capacity.



% add_student(SID,[H|T],Hc):- add_student(SID,H,T,Hc).
add_student(SID,Cours,Hc):-
    \+ student(SID,_,_),       % Daha önce ID de bir öğrenci olmamalı.
    check_course(Cours),       % girilen kursların geçerli birer kurs olup olmadığı kontrol edilir.
    check_conflict(Cours,Res), % alınmak istenen derslerin saatleri çakışıyor mu diye kontrol edilir.
    Res == 0,
    assertz(student(SID,Cours,Hc)), %uygunluk kontrol edilmeden önce student objesi oluşturulur ancak uygun koşulları sağlamazsa silinir ve iz bırakmaz.
    (check_available(SID,Cours);retract(student(SID,Cours,Hc)),1 == 2).



% bir sınıf eklemek için sadece o sınıf ıd'sinde daha önce bir sınıf
% olup olmadığını kontrol etmek dışında bir koşul aklıma gelmedi o
% yüzden tek bir koşul kontrolü yapıyorum ve yeni sınıfı oluşturuyorum.
add_room(RID,Cap,Eq):-

    \+ room(RID,_,_),
    assertz(room(RID,Cap,Eq)).


%add_course(Course_ID,Instruction_ID,Capacity,Hour,Room_ID,Equipment)
add_course(CID,IID,C,Hour,R,E):-

    \+ course(CID,_,_,_,_,_),  % course ID daha önce alınmış olmamalı
    instructor(IID,_,_),       %instructor ID geçerli bir ID olmalı
    assertz(course(CID,IID,C,Hour,R,E)),
    (assign(R,CID);retract(course(CID,IID,C,Hour,R,E))). % Course verilen Room a assign edilebilirse sorun yok
                                                         % oluşturulan obje korunur ancak atamaya uygun değilse silinir.



% Burada bütün sorumluluğu kullanıcıya bırakıyorum. Kullanıcı occupancy
% tablosu inceleyip bir derse sınıf atadığında her ders saati occupancy
% tablosunu güncellemesi gerekiyor.
add_occupancy(RID,Hour,CID):-
  retract(occupancy(RID,Hour,_)),
  assertz(occupancy(RID,Hour,CID)).


%++++++++++  Y A R D I M C I   K O Ş U L  İ F A D E L E R İ +++++++++++
% Bu methodlar dışarıdan direk kullanıcının kullanmaması gereken
% yardımcı koşul ifadeleri


% verilen iki liste arasında çakışan eleman olup olmadığını kontrol
% etmek için kullanılan bir method.
compare_lists([],_).
compare_lists([H|T],L2):-
    \+member(H,L2),
    compare_lists(T,L2).



%bir öğrencinin kayıt olmak istediği dersin geçerli bir ders olup olmadığını kontrol ediyor.
check_course([]).
check_course([H|T]):-
    course(H,_,_,_,_,_),
    check_course(T).




% Bu fonksiyon L1 parametresi olarak verilen listenin elemanlarının L2
% listesinde olup olmadığını kontrol eder. L1 in bütün elemanları L2 de
% varsa True , diğer durumda false döner.
include_lists(L1,L2):-
    length(L1,LL1),
    length(L2,LL2),
    LL1 =< LL2,
    include_backend(L1,L2).

include_backend([],_).
include_backend([H|T],L2):-
    member(H,L2),
    include_backend(T,L2).




% parametre olarak gelen sınıfta toplam kaç boş ders saati olduğunu
% hesaplayan fonksiyon.
free_time(18,_,Count,C):- C =< Count.
free_time(Hour,RID,Count,C):-
    Hour < 18,
    occupancy(RID,Hour,CD1),
    CD1 == n,
    Hour1 is Hour + 1,
    K is Count + 1,
    free_time(Hour1,RID,K,C).

free_time(Hour,RID,Count,C):-
    Hour < 18,
    Hour1 is Hour + 1,
    free_time(Hour1,RID,Count,C).




%hours of courses
% bir dersin işlendiği saatleri bize bir liste halinde döndürür.
% Örn: cse341 için [8,9,10,11]
course_hour(18,CID,Count,Count):- course(CID,_,_,X,_,_),length(Count,Len),Len == X.
course_hour(Hour,CD1,Count,C):-
    Hour < 18,
    occupancy(_,Hour,CD1),
    Hour1 is Hour + 1,
    append(Count,[Hour],Res),
    course_hour(Hour1,CD1,Res,C).

course_hour(Hour,CID,Count,C):-
    Hour < 18,
    Hour1 is Hour + 1,
    course_hour(Hour1,CID,Count,C).



% Verilen course ID ye sahip kursa kaç öğrencinin kayıtlı olduğu
% hesaplayıp döndürür. Orn: cse341 dersi için başlangıc durumu için
% Res değeri 10 dur.
course_counterr(CID,Res):- course_counterr(0,CID,[],X), length(X,Res),!.

course_counterr(100,_,Count,Count).

course_counterr(SID,CD1,Count,C):-
    SID < 100,
    student(SID,Courses,_),
    include_lists([CD1],Courses),

    (\+member(SID,Count),append(Count,[SID],Res);member(SID,Count)),
    SID1 is SID + 1,
    course_counterr(SID1,CD1,Res,C).

course_counterr(Hour,CID,Count,C):-
    Hour < 100,
    Hour1 is Hour + 1,
    course_counterr(Hour1,CID,Count,C).




% Parametre olarak gelen course listesindeki derslerin verilen student
% için uygun olduğunu ispatlamak üzerine kurulmuş bir kontrol.
% bütün dersler uygunsa True herhangi biri uygun değilse false olur.
check_available(_,[]).
check_available(SID,[H|T]):-
    enroll(SID,H),
    check_available(SID,T).




% bir listede verilen dersler arasında conflict durumu var mı diye
% kontrol edilen koşul
check_conflict(List,Res):-check_conflict(List,0,Res),!.
check_conflict([_|[]],O,O).
check_conflict([H|[HTail|TTail]],O,N):-
   (conflict(H,HTail),K is O + 1;K is O),
   check_conflict([HTail|TTail],K,N).



