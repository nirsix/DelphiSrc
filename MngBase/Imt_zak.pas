// ������ ������������ �������

unit Imt_zak;

interface

uses  ImportIdx;


procedure addL_ty(idreg: integer; SubRegName:string; TypeLoc:integer; NameLocal:string; indecs: integer);
procedure addL_kv(indecs: integer);
procedure Add_TotalZakarpatskaya;
procedure Add_KievIndecs;

implementation


procedure addL_ty(idreg: integer; SubRegName:string; TypeLoc:integer; NameLocal:string; indecs: integer);
var
  idsr: integer;
begin
 idsr := ITB_SubRegion( SubRegName, idreg);
 ITB_CityLocality(NameLocal, indecs, idsr, TypeLoc);
end;

// ����
procedure addL_kv(indecs: integer);
begin
 ITB_CityLocality('���', indecs, 1, 1);
end;


procedure Add_TotalZakarpatskaya;
begin
addL_ty(7,'�����������',5,'��������',90253);
addL_ty(7,'�����������',5,'�����',90211);
addL_ty(7,'�����������',5,'�������',90213);
addL_ty(7,'�����������',5,'�������',90212);
addL_ty(7,'�����������',5,'����',90261);
addL_ty(7,'�����������',3,'��������',90200);
addL_ty(7,'�����������',3,'��������',90201);
addL_ty(7,'�����������',3,'��������',90202);
addL_ty(7,'�����������',3,'��������',90203);
addL_ty(7,'�����������',3,'��������',90204);
addL_ty(7,'�����������',3,'��������',90205);
addL_ty(7,'�����������',3,'��������',90206);
addL_ty(7,'�����������',3,'��������',90207);
addL_ty(7,'�����������',3,'��������',90208);
addL_ty(7,'�����������',3,'��������',90209);
addL_ty(7,'�����������',5,'�����������',90240);
addL_ty(7,'�����������',5,'�������',90256);
addL_ty(7,'�����������',5,'����',90255);
addL_ty(7,'�����������',5,'������ �����',90252);
addL_ty(7,'�����������',5,'������ �������',90232);
addL_ty(7,'�����������',5,'����� ������',90242);
addL_ty(7,'�����������',5,'�������',90254);
addL_ty(7,'�����������',5,'����',90231);
addL_ty(7,'�����������',5,'�����',90222);
addL_ty(7,'�����������',5,'����',90251);
addL_ty(7,'�����������',5,'���������',90214);
addL_ty(7,'�����������',5,'���',90230);
addL_ty(7,'�����������',5,'�����',90234);
addL_ty(7,'�����������',5,'�������',90224);
addL_ty(7,'�����������',5,'�i����',90243);
addL_ty(7,'�����������',5,'�������',90264);
addL_ty(7,'�����������',5,'������',90223);
addL_ty(7,'�����������',5,'������',90250);
addL_ty(7,'�����������',5,'��泿��',90260);
addL_ty(7,'�����������',5,'����� ������',90241);
addL_ty(7,'�����������',5,'������',90263);
addL_ty(7,'�����������',5,'������',90221);
addL_ty(7,'�����������',5,'���������',90225);
addL_ty(7,'�����������',5,'�������',90210);
addL_ty(7,'�����������',5,'��������',90262);
addL_ty(7,'�����������',5,'���',90220);
addL_ty(7,'�����������',5,'�����',90233);
addL_ty(7,'�������������������',5,'���������',89043);
addL_ty(7,'�������������������',3,'������� ��������',89000);
addL_ty(7,'�������������������',3,'������� ��������',89001);
addL_ty(7,'�������������������',3,'������� ��������',89002);
addL_ty(7,'�������������������',5,'���������-������',89015);
addL_ty(7,'�������������������',5,'�����',89023);
addL_ty(7,'�������������������',5,'���������',89030);
addL_ty(7,'�������������������',5,'�������',89012);
addL_ty(7,'�������������������',5,'������',89003);
addL_ty(7,'�������������������',5,'������',89011);
addL_ty(7,'�������������������',5,'��������',89022);
addL_ty(7,'�������������������',5,'�����',89013);
addL_ty(7,'�������������������',5,'����',89033);
addL_ty(7,'�������������������',5,'����� ��������',89040);
addL_ty(7,'�������������������',5,'��������� ������',89041);
addL_ty(7,'�������������������',5,'ѳ��',89021);
addL_ty(7,'�������������������',5,'���������',89044);
addL_ty(7,'�������������������',5,'������',89014);
addL_ty(7,'�������������������',5,'��������',89020);
addL_ty(7,'�������������������',5,'�������',89010);
addL_ty(7,'�������������������',5,'�����',89032);
addL_ty(7,'�������������������',5,'����',89031);
addL_ty(7,'�������������������',5,'�����������',89042);
addL_ty(7,'��������������',5,'������',90355);
addL_ty(7,'��������������',5,'����������',90310);
addL_ty(7,'��������������',5,'������',90315);
addL_ty(7,'��������������',5,'������ ������',90330);
addL_ty(7,'��������������',5,'������ ������',90370);
addL_ty(7,'��������������',5,'����� ������',90312);
addL_ty(7,'��������������',5,'���������',90322);
addL_ty(7,'��������������',5,'������',90336);
addL_ty(7,'��������������',5,'�����',90351);
addL_ty(7,'��������������',3,'���������',90300);
addL_ty(7,'��������������',3,'���������',90301);
addL_ty(7,'��������������',3,'���������',90302);
addL_ty(7,'��������������',3,'���������',90303);
addL_ty(7,'��������������',3,'���������',90304);
addL_ty(7,'��������������',3,'���������',90305);
addL_ty(7,'��������������',5,'������',90362);
addL_ty(7,'��������������',5,'����',90344);
addL_ty(7,'��������������',5,'ĳ�����',90356);
addL_ty(7,'��������������',5,'��������',90353);
addL_ty(7,'��������������',5,'����',90364);
addL_ty(7,'��������������',5,'������',90365);
addL_ty(7,'��������������',5,'���������',90371);
addL_ty(7,'��������������',5,'��������',90332);
addL_ty(7,'��������������',5,'���� ������',90331);
addL_ty(7,'��������������',5,'�������',90326);
addL_ty(7,'��������������',5,'���� ����',90350);
addL_ty(7,'��������������',5,'����������',90341);
addL_ty(7,'��������������',5,'�������',90324);
addL_ty(7,'��������������',5,'����',90313);
addL_ty(7,'��������������',5,'����������',90320);
addL_ty(7,'��������������',5,'�������',90354);
addL_ty(7,'��������������',5,'ϳ����������',90325);
addL_ty(7,'��������������',5,'������',90321);
addL_ty(7,'��������������',5,'������',90360);
addL_ty(7,'��������������',5,'������',90343);
addL_ty(7,'��������������',5,'���������',90352);
addL_ty(7,'��������������',5,'����',90342);
addL_ty(7,'��������������',5,'����',90361);
addL_ty(7,'��������������',5,'�����',90340);
addL_ty(7,'��������������',5,'������ ����',90323);
addL_ty(7,'��������������',5,'���������',90363);
addL_ty(7,'��������������',5,'�������',90311);
addL_ty(7,'��������������',5,'������',90314);
addL_ty(7,'������������',5,'�������',89122);
addL_ty(7,'������������',5,'����������',89111);
addL_ty(7,'������������',5,'��������',89114);
addL_ty(7,'������������',5,'����`��',89113);
addL_ty(7,'������������',5,'������ ������',89132);
addL_ty(7,'������������',3,'��������',89100);
addL_ty(7,'������������',3,'��������',89101);
addL_ty(7,'������������',3,'��������',89102);
addL_ty(7,'������������',3,'��������',89103);
addL_ty(7,'������������',3,'��������',89104);
addL_ty(7,'������������',5,'��������',89140);
addL_ty(7,'������������',5,'��������',89120);
addL_ty(7,'������������',5,'����',89131);
addL_ty(7,'������������',5,'����� ������',89130);
addL_ty(7,'������������',5,'ϳ��������',89121);
addL_ty(7,'������������',5,'�������',89141);
addL_ty(7,'������������',5,'����������',89133);
addL_ty(7,'������������',5,'�����',89112);
addL_ty(7,'������������',5,'���������',89110);
addL_ty(7,'����������',5,'��������',90120);
addL_ty(7,'����������',5,'�����',90132);
addL_ty(7,'����������',5,'���',90115);
addL_ty(7,'����������',5,'�������',90152);
addL_ty(7,'����������',5,'������� ��������',90143);
addL_ty(7,'����������',5,'³�������',90141);
addL_ty(7,'����������',5,'������',90140);
addL_ty(7,'����������',5,'ĳ�����',90133);
addL_ty(7,'����������',5,'�����',90154);
addL_ty(7,'����������',5,'�����������',90113);
addL_ty(7,'����������',5,'���������',90121);
addL_ty(7,'����������',5,'�������',90112);
addL_ty(7,'����������',5,'������',90123);
addL_ty(7,'����������',5,'�������',90130);
addL_ty(7,'����������',5,'���������',90134);
addL_ty(7,'����������',3,'������',90100);
addL_ty(7,'����������',3,'������',90101);
addL_ty(7,'����������',3,'������',90102);
addL_ty(7,'����������',3,'������',90103);
addL_ty(7,'����������',3,'������',90104);
addL_ty(7,'����������',5,'���������',90125);
addL_ty(7,'����������',5,'�������',90151);
addL_ty(7,'����������',5,'��������',90150);
addL_ty(7,'����������',5,'������',90156);
addL_ty(7,'����������',5,'����� ��������',90144);
addL_ty(7,'����������',5,'̳������',90122);
addL_ty(7,'����������',5,'�������',90114);
addL_ty(7,'����������',5,'����� �������',90142);
addL_ty(7,'����������',5,'���',90131);
addL_ty(7,'����������',5,'ϳ�����',90111);
addL_ty(7,'����������',5,'�������������',90155);
addL_ty(7,'����������',5,'ѳ����',90124);
addL_ty(7,'����������',5,'����',90153);
addL_ty(7,'����������',5,'�������',90126);
addL_ty(7,'����������',5,'������ ����',90110);
addL_ty(7,'̳��������',5,'��������',90021);
addL_ty(7,'̳��������',5,'������� �������',90025);
addL_ty(7,'̳��������',5,'�������',90046);
addL_ty(7,'̳��������',5,'�������',90023);
addL_ty(7,'̳��������',5,'����������',90005);
addL_ty(7,'̳��������',5,'����',90020);
addL_ty(7,'̳��������',5,'�������',90022);
addL_ty(7,'̳��������',5,'��������',90043);
addL_ty(7,'̳��������',5,'��������',90044);
addL_ty(7,'̳��������',5,'��������',90045);
addL_ty(7,'̳��������',5,'˳�������',90012);
addL_ty(7,'̳��������',5,'����������',90034);
addL_ty(7,'̳��������',5,'������',90024);
addL_ty(7,'̳��������',3,'̳����',90000);
addL_ty(7,'̳��������',3,'̳����',90001);
addL_ty(7,'̳��������',3,'̳����',90002);
addL_ty(7,'̳��������',3,'̳����',90003);
addL_ty(7,'̳��������',3,'̳����',90004);
addL_ty(7,'̳��������',5,'���������',90042);
addL_ty(7,'̳��������',5,'������ ��������',90010);
addL_ty(7,'̳��������',5,'����������',90013);
addL_ty(7,'̳��������',5,'��������',90011);
addL_ty(7,'̳��������',5,'������',90014);
addL_ty(7,'̳��������',5,'�������',90032);
addL_ty(7,'̳��������',5,'г���',90030);
addL_ty(7,'̳��������',5,'�������',90041);
addL_ty(7,'̳��������',5,'����������� ������',90040);
addL_ty(7,'̳��������',5,'�����',90033);
addL_ty(7,'̳��������',5,'������',90015);
addL_ty(7,'̳��������',5,'�����',90031);
addL_ty(7,'������������',5,'������',89663);
addL_ty(7,'������������',5,'�������',89677);
addL_ty(7,'������������',5,'���������',89654);
addL_ty(7,'������������',5,'���������',89665);
addL_ty(7,'������������',5,'��������',89645);
addL_ty(7,'������������',5,'��������',89632);
addL_ty(7,'������������',5,'������',89646);
addL_ty(7,'������������',5,'����� �����',89625);
addL_ty(7,'������������',5,'������� ��������',89660);
addL_ty(7,'������������',5,'������ �������',89644);
addL_ty(7,'������������',5,'�������',89656);
addL_ty(7,'������������',5,'������',89671);
addL_ty(7,'������������',5,'�������',89657);
addL_ty(7,'������������',5,'��������',89667);
addL_ty(7,'������������',5,'�������',89675);
addL_ty(7,'������������',5,'��������',89650);
addL_ty(7,'������������',5,'������',89674);
addL_ty(7,'������������',5,'��������',89622);
addL_ty(7,'������������',5,'�������',89633);
addL_ty(7,'������������',5,'�������',89641);
addL_ty(7,'������������',5,'���������',89637);
addL_ty(7,'������������',5,'��������',89626);
addL_ty(7,'������������',5,'���������',89623);
addL_ty(7,'������������',5,'��������',89636);
addL_ty(7,'������������',5,'���������',89631);
addL_ty(7,'������������',5,'������',89661);
addL_ty(7,'������������',5,'�����������',89662);
addL_ty(7,'������������',5,'�����',89635);
addL_ty(7,'������������',5,'������',89664);
addL_ty(7,'������������',5,'������',89634);
addL_ty(7,'������������',5,'���������',89676);
addL_ty(7,'������������',3,'��������',89600);
addL_ty(7,'������������',3,'��������',89601);
addL_ty(7,'������������',3,'��������',89602);
addL_ty(7,'������������',3,'��������',89603);
addL_ty(7,'������������',3,'��������',89604);
addL_ty(7,'������������',3,'��������',89605);
addL_ty(7,'������������',3,'��������',89606);
addL_ty(7,'������������',3,'��������',89607);
addL_ty(7,'������������',3,'��������',89608);
addL_ty(7,'������������',3,'��������',89609);
addL_ty(7,'������������',3,'��������',89610);
addL_ty(7,'������������',3,'��������',89611);
addL_ty(7,'������������',3,'��������',89612);
addL_ty(7,'������������',3,'��������',89613);
addL_ty(7,'������������',3,'��������',89614);
addL_ty(7,'������������',3,'��������',89615);
addL_ty(7,'������������',3,'��������',89616);
addL_ty(7,'������������',3,'��������',89617);
addL_ty(7,'������������',3,'��������',89618);
addL_ty(7,'������������',3,'��������',89619);
addL_ty(7,'������������',5,'������ ��������',89670);
addL_ty(7,'������������',5,'���� ���������',89624);
addL_ty(7,'������������',5,'����������',89666);
addL_ty(7,'������������',5,'�����',89643);
addL_ty(7,'������������',5,'�������',89627);
addL_ty(7,'������������',5,'ϳ��������',89673);
addL_ty(7,'������������',5,'���������',89630);
addL_ty(7,'������������',5,'��������',89620);
addL_ty(7,'������������',5,'������',89621);
addL_ty(7,'������������',5,'�����',89653);
addL_ty(7,'������������',5,'�����',89642);
addL_ty(7,'������������',5,'�������',89668);
addL_ty(7,'������������',5,'����������',89655);
addL_ty(7,'������������',5,'������',89672);
addL_ty(7,'������������',5,'����������',89651);
addL_ty(7,'������������',5,'���������',89640);
addL_ty(7,'������������',5,'�������',89652);
addL_ty(7,'������������',5,'³�������',89214);
addL_ty(7,'������������',5,'��������',89220);
addL_ty(7,'������������',5,'���������',89210);
addL_ty(7,'������������',5,'�������',89212);
addL_ty(7,'������������',5,'����������',89211);
addL_ty(7,'������������',3,'�������',89200);
addL_ty(7,'������������',3,'�������',89201);
addL_ty(7,'������������',3,'�������',89202);
addL_ty(7,'������������',5,'���������',89230);
addL_ty(7,'������������',5,'������',89224);
addL_ty(7,'������������',5,'ѳ���',89203);
addL_ty(7,'������������',5,'ѳ�����',89213);
addL_ty(7,'������������',5,'������',89222);
addL_ty(7,'������������',5,'�������',89215);
addL_ty(7,'������������',5,'��� ������',89221);
addL_ty(7,'������������',5,'����-������',89231);
addL_ty(7,'������������',5,'����-�����',89223);
addL_ty(7,'������������',5,'����-������',89232);
addL_ty(7,'����������',5,'���� ������',90614);
addL_ty(7,'����������',5,'�����',90643);
addL_ty(7,'����������',5,'������',90645);
addL_ty(7,'����������',5,'������� �����',90615);
addL_ty(7,'����������',5,'������ ������',90611);
addL_ty(7,'����������',5,'��������',90646);
addL_ty(7,'����������',5,'³���������',90624);
addL_ty(7,'����������',5,'������',90610);
addL_ty(7,'����������',5,'ĳ����',90625);
addL_ty(7,'����������',5,'�����',90640);
addL_ty(7,'����������',5,'�����',90641);
addL_ty(7,'����������',5,'�����',90642);
addL_ty(7,'����������',5,'���������� ������',90620);
addL_ty(7,'����������',5,'�������� ������',90621);
addL_ty(7,'����������',5,'���������',90623);
addL_ty(7,'����������',5,'��������',90633);
addL_ty(7,'����������',5,'���',90616);
addL_ty(7,'����������',5,'����',90647);
addL_ty(7,'����������',3,'�����',90600);
addL_ty(7,'����������',3,'�����',90601);
addL_ty(7,'����������',3,'�����',90602);
addL_ty(7,'����������',3,'�����',90603);
addL_ty(7,'����������',3,'�����',90604);
addL_ty(7,'����������',5,'�������',90644);
addL_ty(7,'����������',5,'������',90622);
addL_ty(7,'����������',5,'������ ������',90613);
addL_ty(7,'����������',5,'�������',90631);
addL_ty(7,'����������',5,'�������',90612);
addL_ty(7,'����������',5,'����� ����',90632);
addL_ty(7,'����������',5,'����',90630);
addL_ty(7,'�����������',5,'���������',89335);
addL_ty(7,'�����������',5,'����������',89312);
addL_ty(7,'�����������',5,'��������',89320);
addL_ty(7,'�����������',5,'�������',89307);
addL_ty(7,'�����������',5,'������',89332);
addL_ty(7,'�����������',5,'��������',89334);
addL_ty(7,'�����������',5,'�������',89308);
addL_ty(7,'�����������',5,'�����',89323);
addL_ty(7,'�����������',5,'������',89311);
addL_ty(7,'�����������',5,'������',89313);
addL_ty(7,'�����������',5,'������',89314);
addL_ty(7,'�����������',5,'������',89315);
addL_ty(7,'�����������',5,'������',89316);
addL_ty(7,'�����������',5,'���������',89310);
addL_ty(7,'�����������',5,'�����',89333);
addL_ty(7,'�����������',5,'������',89309);
addL_ty(7,'�����������',3,'�������',89300);
addL_ty(7,'�����������',3,'�������',89301);
addL_ty(7,'�����������',3,'�������',89302);
addL_ty(7,'�����������',3,'�������',89303);
addL_ty(7,'�����������',3,'�������',89304);
addL_ty(7,'�����������',3,'�������',89305);
addL_ty(7,'�����������',3,'�������',89306);
addL_ty(7,'�����������',5,'�������',89321);
addL_ty(7,'�����������',5,'�������',89331);
addL_ty(7,'�����������',5,'�������',89322);
addL_ty(7,'�����������',5,'������',89330);
addL_ty(7,'����������',5,'�������',90561);
addL_ty(7,'����������',5,'���������',90562);
addL_ty(7,'����������',5,'�������',90556);
addL_ty(7,'����������',5,'������ �������',90515);
addL_ty(7,'����������',5,'���������',90546);
addL_ty(7,'����������',5,'³�������',90542);
addL_ty(7,'����������',5,'³�������-����',90544);
addL_ty(7,'����������',5,'³��������',90543);
addL_ty(7,'����������',5,'��������',90553);
addL_ty(7,'����������',5,'������',90535);
addL_ty(7,'����������',5,'�������� ����',90574);
addL_ty(7,'����������',5,'�������',90570);
addL_ty(7,'����������',5,'ĳ�����',90571);
addL_ty(7,'����������',5,'����������',90560);
addL_ty(7,'����������',5,'������',90531);
addL_ty(7,'����������',5,'������',90513);
addL_ty(7,'����������',5,'������',90532);
addL_ty(7,'����������',5,'�������',90512);
addL_ty(7,'����������',5,'������',90523);
addL_ty(7,'����������',5,'�����',90563);
addL_ty(7,'����������',5,'�������',90511);
addL_ty(7,'����������',5,'����',90554);
addL_ty(7,'����������',5,'�������',90522);
addL_ty(7,'����������',5,'���������',90540);
addL_ty(7,'����������',5,'����������',90552);
addL_ty(7,'����������',5,'����������',90533);
addL_ty(7,'����������',5,'�������',90555);
addL_ty(7,'����������',5,'ϳ������',90541);
addL_ty(7,'����������',5,'������',90572);
addL_ty(7,'����������',5,'������ �����',90521);
addL_ty(7,'����������',5,'������ ����',90551);
addL_ty(7,'����������',5,'���������',90575);
addL_ty(7,'����������',5,'���������',90576);
addL_ty(7,'����������',5,'���������',90577);
addL_ty(7,'����������',5,'���������',90578);
addL_ty(7,'����������',5,'��������',90530);
addL_ty(7,'����������',5,'�������',90550);
addL_ty(7,'����������',5,'�������',90564);
addL_ty(7,'����������',5,'�������',90545);
addL_ty(7,'����������',5,'��������',90534);
addL_ty(7,'����������',5,'�������',90573);
addL_ty(7,'����������',3,'�����',90500);
addL_ty(7,'����������',3,'�����',90501);
addL_ty(7,'����������',3,'�����',90502);
addL_ty(7,'����������',3,'�����',90503);
addL_ty(7,'����������',3,'�����',90504);
addL_ty(7,'����������',3,'�����',90505);
addL_ty(7,'����������',3,'�����',90506);
addL_ty(7,'����������',3,'�����',90507);
addL_ty(7,'����������',3,'�����',90508);
addL_ty(7,'����������',3,'�������',90509);
addL_ty(7,'����������',5,'����',90514);
addL_ty(7,'����������',5,'����-�����',90520);
addL_ty(7,'����������',5,'���������',90510);
addL_ty(7,'����������',5,'������� ���',90516);
addL_ty(7,'����������',2,'�������',88000);
addL_ty(7,'����������',2,'�������',88001);
addL_ty(7,'����������',2,'�������',88002);
addL_ty(7,'����������',2,'�������',88003);
addL_ty(7,'����������',2,'�������',88004);
addL_ty(7,'����������',2,'�������',88005);
addL_ty(7,'����������',2,'�������',88006);
addL_ty(7,'����������',2,'�������',88007);
addL_ty(7,'����������',2,'�������',88008);
addL_ty(7,'����������',2,'�������',88009);
addL_ty(7,'����������',2,'�������',88010);
addL_ty(7,'����������',2,'�������',88011);
addL_ty(7,'����������',2,'�������',88012);
addL_ty(7,'����������',2,'�������',88013);
addL_ty(7,'����������',2,'�������',88014);
addL_ty(7,'����������',2,'�������',88015);
addL_ty(7,'����������',2,'�������',88016);
addL_ty(7,'����������',2,'�������',88017);
addL_ty(7,'����������',2,'�������',88018);
addL_ty(7,'����������',2,'�������',88019);
addL_ty(7,'����������',2,'�������',88020);
addL_ty(7,'������������',5,'�������',89454);
addL_ty(7,'������������',5,'���������',89471);
addL_ty(7,'������������',5,'���������',89425);
addL_ty(7,'������������',5,'������ �������',89463);
addL_ty(7,'������������',5,'����� �����',89434);
addL_ty(7,'������������',5,'����� ����',89440);
addL_ty(7,'������������',5,'�����',89430);
addL_ty(7,'������������',5,'�������',89441);
addL_ty(7,'������������',5,'�������',89445);
addL_ty(7,'������������',5,'�����',89461);
addL_ty(7,'������������',5,'������',89453);
addL_ty(7,'������������',5,'��������',89411);
addL_ty(7,'������������',5,'�������',89450);
addL_ty(7,'������������',5,'�������',89423);
addL_ty(7,'������������',5,'���������',89435);
addL_ty(7,'������������',5,'���� �������',89464);
addL_ty(7,'������������',5,'��������',89410);
addL_ty(7,'������������',5,'����� ���������',89442);
addL_ty(7,'������������',5,'�������',89412);
addL_ty(7,'������������',5,'��������',89413);
addL_ty(7,'������������',5,'������-��������',89431);
addL_ty(7,'������������',5,'����������',89451);
addL_ty(7,'������������',5,'�������',89433);
addL_ty(7,'������������',5,'������',89424);
addL_ty(7,'������������',5,'����� ��������',89443);
addL_ty(7,'������������',5,'�������',89452);
addL_ty(7,'������������',5,'�������',89462);
addL_ty(7,'������������',5,'����������',89460);
addL_ty(7,'������������',5,'����������',89421);
addL_ty(7,'������������',5,'�����',89432);
addL_ty(7,'������������',5,'��������',89420);
addL_ty(7,'������������',5,'������� �����',89400);
addL_ty(7,'������������',5,'������',89422);
addL_ty(7,'������������',5,'������',89444);
addL_ty(7,'������������',5,'��������',89415);
addL_ty(7,'������������',5,'���������',89455);
addL_ty(7,'������������',5,'����',89414);
addL_ty(7,'���������',5,'��������',90426);
addL_ty(7,'���������',5,'��������',90442);
addL_ty(7,'���������',5,'��������',90453);
addL_ty(7,'���������',5,'������',90411);
addL_ty(7,'���������',5,'�������',90454);
addL_ty(7,'���������',5,'�������',90455);
addL_ty(7,'���������',5,'�������',90456);
addL_ty(7,'���������',5,'³������',90424);
addL_ty(7,'���������',5,'��������',90430);
addL_ty(7,'���������',5,'��������',90443);
addL_ty(7,'���������',5,'�������',90432);
addL_ty(7,'���������',5,'������',90428);
addL_ty(7,'���������',5,'�����',90414);
addL_ty(7,'���������',5,'�����������',90441);
addL_ty(7,'���������',5,'���',90436);
addL_ty(7,'���������',5,'ʳ����',90409);
addL_ty(7,'���������',5,'ʳ�����',90431);
addL_ty(7,'���������',5,'���������',90433);
addL_ty(7,'���������',5,'���������',90413);
addL_ty(7,'���������',5,'����������',90452);
addL_ty(7,'���������',5,'�����',90412);
addL_ty(7,'���������',5,'�������� ������',90425);
addL_ty(7,'���������',5,'��������',90416);
addL_ty(7,'���������',5,'�����',90415);
addL_ty(7,'���������',5,'�����������',90427);
addL_ty(7,'���������',5,'�������',90435);
addL_ty(7,'���������',5,'����� ������',90440);
addL_ty(7,'���������',5,'������ �������',90420);
addL_ty(7,'���������',5,'������ �������',90421);
addL_ty(7,'���������',5,'������ �������',90422);
addL_ty(7,'���������',5,'������������',90444);
addL_ty(7,'���������',5,'��������',90410);
addL_ty(7,'���������',5,'���������',90450);
addL_ty(7,'���������',5,'��������',90451);
addL_ty(7,'���������',3,'����',90400);
addL_ty(7,'���������',3,'����',90401);
addL_ty(7,'���������',3,'����',90402);
addL_ty(7,'���������',3,'����',90403);
addL_ty(7,'���������',3,'����',90404);
addL_ty(7,'���������',3,'����',90405);
addL_ty(7,'���������',3,'����',90406);
addL_ty(7,'���������',3,'����',90407);
addL_ty(7,'���������',3,'����',90408);
addL_ty(7,'���������',3,'�������',90434);
addL_ty(7,'���������',5,'����',90457);
addL_ty(7,'���������',5,'������',90423);
addL_ty(7,'���������',5,'���������',90458);
addL_ty(7,'��������',2,'���',89500);
addL_ty(7,'��������',2,'���',89501);
addL_ty(7,'��������',2,'���',89502);
addL_ty(7,'��������',2,'���',89503);
addL_ty(7,'��������',2,'���',89504);
addL_ty(7,'��������',2,'���',89505);
addL_ty(7,'��������',2,'���',89506);
addL_ty(7,'��������',2,'���',89507);
addL_ty(7,'��������',2,'���',89508);
addL_ty(7,'��������',2,'���',89509);
addL_ty(7,'��������',2,'���',89510);
end;

procedure Add_KievIndecs;
begin
addL_kv(04027);
addL_kv(02153);
addL_kv(01154);
addL_kv(03011);
addL_kv(02015);
addL_kv(03076);
addL_kv(01118);
addL_kv(02049);
addL_kv(01146);
addL_kv(03032);
addL_kv(02070);
addL_kv(04052);
addL_kv(03042);
addL_kv(01012);
addL_kv(04023);
addL_kv(04090);
addL_kv(03139);
addL_kv(03145);
addL_kv(01057);
addL_kv(04007);
addL_kv(04168);
addL_kv(04158);
addL_kv(03149);
addL_kv(01123);
addL_kv(01085);
addL_kv(04145);
addL_kv(03114);
addL_kv(03125);
addL_kv(01072);
addL_kv(03060);
addL_kv(03447);
addL_kv(03088);
addL_kv(02009);
addL_kv(01100);
addL_kv(02030);
addL_kv(04197);
addL_kv(03198);
addL_kv(04102);
addL_kv(02048);
addL_kv(04115);
addL_kv(02171);
addL_kv(01077);
addL_kv(04148);
addL_kv(01117);
addL_kv(04126);
addL_kv(02071);
addL_kv(04098);
addL_kv(04165);
addL_kv(02106);
addL_kv(01106);
addL_kv(02182);
addL_kv(04302);
addL_kv(04093);
addL_kv(03200);
addL_kv(02036);
addL_kv(02020);
addL_kv(02145);
addL_kv(04104);
addL_kv(03144);
addL_kv(01148);
addL_kv(03075);
addL_kv(03180);
addL_kv(01092);
addL_kv(04068);
addL_kv(01153);
addL_kv(04038);
addL_kv(04160);
addL_kv(02023);
addL_kv(04092);
addL_kv(04082);
addL_kv(03070);
addL_kv(04039);
addL_kv(03094);
addL_kv(02017);
addL_kv(02052);
addL_kv(01134);
addL_kv(04041);
addL_kv(04162);
addL_kv(02302);
addL_kv(01079);
addL_kv(03012);
addL_kv(02124);
addL_kv(02167);
addL_kv(02155);
addL_kv(02013);
addL_kv(01075);
addL_kv(01094);
addL_kv(01062);
addL_kv(02188);
addL_kv(01067);
addL_kv(02231);
addL_kv(02301);
addL_kv(02178);
addL_kv(03117);
addL_kv(03044);
addL_kv(01038);
addL_kv(02126);
addL_kv(01026);
addL_kv(04029);
addL_kv(02115);
addL_kv(02080);
addL_kv(04200);
addL_kv(01140);
addL_kv(01071);
addL_kv(01059);
addL_kv(01111);
addL_kv(04178);
addL_kv(01093);
addL_kv(01108);
addL_kv(03017);
addL_kv(01000);
addL_kv(04109);
addL_kv(03466);
addL_kv(02169);
addL_kv(04055);
addL_kv(04045);
addL_kv(02109);
addL_kv(04103);
addL_kv(01029);
addL_kv(03196);
addL_kv(02085);
addL_kv(01139);
addL_kv(01107);
addL_kv(02005);
addL_kv(04100);
addL_kv(02101);
addL_kv(02107);
addL_kv(01089);
addL_kv(04142);
addL_kv(01158);
addL_kv(02076);
addL_kv(03091);
addL_kv(02200);
addL_kv(02012);
addL_kv(02022);
addL_kv(03105);
addL_kv(03104);
addL_kv(04173);
addL_kv(03020);
addL_kv(01131);
addL_kv(03051);
addL_kv(04203);
addL_kv(03158);
addL_kv(03159);
addL_kv(02059);
addL_kv(03160);
addL_kv(01109);
addL_kv(04305);
addL_kv(04187);
addL_kv(04018);
addL_kv(02216);
addL_kv(04051);
addL_kv(01143);
addL_kv(03023);
addL_kv(01061);
addL_kv(04185);
addL_kv(04085);
addL_kv(04149);
addL_kv(02318);
addL_kv(01159);
addL_kv(02306);
addL_kv(02186);
addL_kv(03080);
addL_kv(02045);
addL_kv(02311);
addL_kv(04079);
addL_kv(04181);
addL_kv(02151);
addL_kv(04133);
addL_kv(02067);
addL_kv(04143);
addL_kv(01115);
addL_kv(04097);
addL_kv(04130);
addL_kv(02173);
addL_kv(01084);
addL_kv(01098);
addL_kv(02134);
addL_kv(03147);
addL_kv(03010);
addL_kv(02199);
addL_kv(01053);
addL_kv(01095);
addL_kv(03029);
addL_kv(01043);
addL_kv(04019);
addL_kv(04139);
addL_kv(03121);
addL_kv(03078);
addL_kv(03046);
addL_kv(01142);
addL_kv(01112);
addL_kv(02309);
addL_kv(01039);
addL_kv(02041);
addL_kv(03093);
addL_kv(03183);
addL_kv(03167);
addL_kv(04167);
addL_kv(04141);
addL_kv(04157);
addL_kv(02304);
addL_kv(02060);
addL_kv(02086);
addL_kv(02163);
addL_kv(04176);
addL_kv(04205);
addL_kv(03047);
addL_kv(01018);
addL_kv(01196);
addL_kv(04111);
addL_kv(03084);
addL_kv(04215);
addL_kv(01015);
addL_kv(03048);
addL_kv(03194);
addL_kv(03162);
addL_kv(03143);
addL_kv(02217);
addL_kv(03057);
addL_kv(02147);
addL_kv(01008);
addL_kv(04136);
addL_kv(04112);
addL_kv(01042);
addL_kv(04213);
addL_kv(03065);
addL_kv(03146);
addL_kv(04214);
addL_kv(04075);
addL_kv(04208);
addL_kv(04211);
addL_kv(02154);
addL_kv(02105);
addL_kv(01054);
addL_kv(03087);
addL_kv(03067);
addL_kv(03141);
addL_kv(03168);
addL_kv(01033);
addL_kv(01034);
addL_kv(01030);
addL_kv(03045);
addL_kv(01021);
addL_kv(03191);
addL_kv(02094);
addL_kv(01103);
addL_kv(03142);
addL_kv(02091);
addL_kv(04071);
addL_kv(03169);
addL_kv(02218);
addL_kv(02183);
addL_kv(03124);
addL_kv(03127);
addL_kv(03129);
addL_kv(03040);
addL_kv(02125);
addL_kv(02175);
addL_kv(02166);
addL_kv(02156);
addL_kv(03055);
addL_kv(03056);
addL_kv(03058);
addL_kv(02096);
addL_kv(03131);
addL_kv(02093);
addL_kv(02206);
addL_kv(02192);
addL_kv(03069);
addL_kv(02230);
addL_kv(04080);
addL_kv(03049);
addL_kv(04210);
addL_kv(04212);
addL_kv(04209);
addL_kv(03041);
addL_kv(03134);
addL_kv(02139);
addL_kv(04123);
addL_kv(01001);
addL_kv(04128);
addL_kv(02098);
addL_kv(02152);
addL_kv(02160);
addL_kv(04201);
addL_kv(02089);
addL_kv(04060);
addL_kv(04116);
addL_kv(04119);
addL_kv(04078);
addL_kv(01032);
addL_kv(03126);
addL_kv(02081);
addL_kv(01014);
addL_kv(01023);
addL_kv(01004);
addL_kv(03026);
addL_kv(01013);
addL_kv(03150);
addL_kv(01220);
addL_kv(01024);
addL_kv(01009);
addL_kv(02232);
addL_kv(02222);
addL_kv(02225);
addL_kv(03118);
addL_kv(03061);
addL_kv(04086);
addL_kv(03039);
addL_kv(03028);
addL_kv(02100);
addL_kv(02140);
addL_kv(03190);
addL_kv(04077);
addL_kv(02002);
addL_kv(03187);
addL_kv(02099);
addL_kv(03179);
addL_kv(03036);
addL_kv(03151);
addL_kv(03138);
addL_kv(02068);
addL_kv(03170);
addL_kv(03113);
addL_kv(04050);
addL_kv(04053);
addL_kv(04073);
addL_kv(01011);
addL_kv(01133);
addL_kv(03083);
addL_kv(02132);
addL_kv(04108);
addL_kv(03164);
addL_kv(03186);
addL_kv(01135);
addL_kv(01025);
addL_kv(04070);
addL_kv(03022);
addL_kv(03038);
addL_kv(02090);
addL_kv(02092);
addL_kv(03115);
addL_kv(03110);
addL_kv(03062);
addL_kv(03027);
addL_kv(04107);
addL_kv(01010);
addL_kv(03037);
addL_kv(03035);
addL_kv(02088);
addL_kv(02121);
addL_kv(04114);
addL_kv(04074);
addL_kv(03148);
end;


end.
