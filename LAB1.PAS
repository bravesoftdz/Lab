{$R+}
{$N+}
{$Q-}
{$S-}
Program Labyrint;
uses Crt,Graph,StLib;

const explCost=30;

const explose=true;
      hide=false;
      explored=true;

type mapArray=array[1..60,1..60] of byte;
type man=object
 x,y:byte;
 g:word;
 vr:byte;
 Procedure DrawMe;
 Procedure MoveMe(mx,my:shortInt);
 Procedure LookAround;
end;

type Score1=record
  names:string[10];
  score:word;
end;
type HiScore=array[1..21] of Score1;

var m:man;
    r,v,map:^MapArray;
    MaxX,MaxY,sz:byte;
    sn,cs:array[0..89] of real;
    ext:boolean;
    x1,y1:integer;
    str1,str2,str3:string;
    lk:word;

    newGame1:boolean;

    last:byte;
    ch:array[1..10] of char;
    LastN:byte;
    show:boolean;
    TempS:score1;
    hi:hiScore;
    lastHi:byte;
    f1:file of HiScore;

    hide1:boolean;

procedure eraseScores;
begin
for i:=1 to 21 do with hi[i] do begin
 names:='??????????';
 score:=100-i*4;
end;
rewrite(f1);
  write(f1,hi);
close(f1);
end;
{----------------------------------------------------------------}
procedure showScores;
begin
  show:=false;
  setFillStyle(1,10);
  bar(480,50,635,300);
  setColor(63);
  rectangle(479,49,636,301);
  line(592,50,592,300);
  for i:=1 to 20 do with hi[i] do begin
    str(score:5,str1);
    str(i  :2,str2);

    setColor(255);
{        if (score=lk) or ((i=1) and (score<lk)) then line(481,74+i*10,634,74+i*10);}
    if (score>=lk) and (hi[i+1].score<lk) then line(481,78+i*10,634,78+i*10);

    if i<>lastHI then setColor(63) else setColor(123);
    outTextXY(485,70+i*10,str2+')'+names);
    outTextXY(594,70+i*10,str1);
  end;
end;
{----------------------------------------------------------------}
procedure sortScores;
begin
for j:=1 to 21 do
  for i:=1 to 20 do
    if hi[i].score<hi[i+1].score then begin
      TempS:=hi[i];
      hi[i]:=hi[i+1];
      hi[i+1]:=TempS;
      if i+1=lastHi then dec(lastHi);
     end
end;
{------------------------------------------------------------------}
procedure Tables;
begin
 for i:=0 to 89 do begin
   sn[i]:=sin((i*4)*Pi/180);
   cs[i]:=cos((i*4)*Pi/180);
 end;
end;
{-----------------------------------------------------------------}
Procedure man.MoveMe(mx,my:shortInt);
begin
x1:=x+mx;
y1:=y+my;
if (x1<=MaxX) and (x1>=1) and (y1<=maxY) and (y1>=1) then begin
 if map^[x1,y1]=2 then begin
   inc(g);
   map^[x1,y1]:=0;
 end;

 if map^[x1,y1]<>1 then begin
  V^[m.x,m.y]:=vr+1;
  R^[m.x,m.y]:=1;
  inc(x,mx);
  inc(y,my);
  V^[m.x,m.y]:=vr+1;
  R^[m.x,m.y]:=1;
 end;
end;
end;
{-----------------------------------------------------------------}
Procedure man.DrawMe;
begin
setColor(254);
outTextXY((x-1)*sz,(y-1)*sz,'X');
outTextXY((x-1)*sz,(y-1)*sz,'!');
outTextXY((x-1)*sz+1,(y-1)*sz+1,'X');
end;
{-----------------------------------------------------------------}
Procedure man.LookAround;
begin
 if hide1=true then
 for i:=1 to maxY do
   for j:=1 to MaxX do if v^[j,i]>1 then begin
     dec(V^[j,i]);
     R^[j,i]:=1;
 end;
 for i:=0 to 89 do begin
   l:=0;
   repeat
    inc(l);
    x1:=x+round(l*cs[i]);
    y1:=y+round(l*sn[i]);
   if (x1>0) and (x1<=MaxX) and (y1>0) and (y1<=MaxY) then begin
    if V^[x1,y1]<Vr-l+1 then begin
      r^[x1,y1]:=1;
      v^[x1,y1]:=Vr-l+1;
    end;
    if map^[x1,y1]=1 then l:=Vr+1;
   end else l:=Vr+1;
   until l>Vr;
 end;
end;
{-----------------------------------------------------------------}
Procedure NewGame;
begin
setFillStyle(1,0);
bar(0,0,639,479);
last:=21;
hi[21].score:=0;
show:=true;
hide1:=false;
newGame1:=false;
randomize;
MaxX:=59;
MaxY:=59;
sz:=8;
m.x:=30+round(random*18-9);
m.y:=30+round(random*18-9);
m.g:=30;
m.vr:=11;
for i:=1 to MaxX do
  for j:=1 to maxY do begin
    v^[j,i]:=0;
    r^[j,i]:=1;
    k:=round(random*99);
    case k of
        0..30:map^[j,i]:=0;
       30..50:map^[j,i]:=2;
       50..99:map^[j,i]:=1;
    end;
  end;
map^[m.x,m.y]:=0;
V^[m.x,m.y]:=m.vr+1;
m.lookAround;
ext:=false;
end;
{-----------------------------------------------------------------}
procedure drawMap;
begin
lk:=0;
for i:=1 to MaxY do
  for j:=1 to maxX do if r^[j,i]>0 then begin
    r^[j,i]:=0;
    x1:=(j-1)*sz;
    y1:=(i-1)*sz;
    if map^[j,i]=1 then setFillStyle(1,V^[j,i]*5) else setFillStyle(1,V^[j,i]*2);
{    if map^[j,i]=1 then setFillStyle(1,round(2*sqr(V^[j,i]/2))) else setFillStyle(1,round(2*sqr(V^[j,i]/3)));}
    if (V^[j,i]=m.vr+1) and (explored=true) then setFillStyle(1,253);
    bar(x1,y1,x1+sz-1,y1+sz-1);
    if map^[j,i]=2 then begin
      setColor(64+round(sqr(V^[j,i]/1.4)));
      circle(x1+sz div 2,y1+sz div 2,sz div 3);
    end;

    setColor(round(V^[j,i]*5.2));
    if j=maxX then line(x1+sz-1,y1     ,x1+sz-1,y1+sz-1);
    if i=maxY then line(x1     ,y1+sz-1,x1+sz-1,y1+sz-1);
    if j=1    then line(x1     ,y1     ,x1     ,y1+sz-1);
    if i=1    then line(x1     ,y1     ,x1+sz-1,y1     );
  end;

for i:=1 to MaxY do
  for j:=1 to maxX do if v^[j,i]>0 then inc(lk);
SetFillStyle(1,0);
bar(500,10,640,30);
setColor(63);
str(lk:5,str1);
str(100*(lk/(maxX*maxY)):5:2,str2);
ouTTextXY(501,11,'S'+str1+'('+str2+'%)');
str(m.g:4,str1);
str(m.Vr:2,str2);
{if m.vr<11 then
  str(m.Vr*3:2,str3);}
ouTTextXY(501,21,'G'+str1{+'/V'+str2+'('+str3+'$)'});

if (last>1) then
if (lk>hi[last-1].score) then begin
  show:=true;
  dec(last);
end;
end;
{-----------------------------------------------------------------}
procedure LookScore;
begin
 if lk>hi[20].score then begin
   for i:=1 to 7 do begin
    if i<7 then k:=80+i*7 else k:=63;
    setColor(k);
    setTextStyle(0,0,i);
    outTextXY(i,240+7*i,'High Score');
    end;
   setTextStyle(0,0,0);
   lastHi:=21;
   hi[21].score:=lk;

   setColor(63);
   rectangle(499,369,631,391);
   setFillStyle(1,10);

   if lastN=0 then for i:=1 to 10 do ch[i]:=chr(0);
   i:=lastN;
   repeat
     bar(500,370,630,390);
     if i>0 then
     for j:=1 to i do outTextXY(520+j*8,375,ch[j]);

     outTextXY(528+i*8,375,'@');
     key:=readKey;
     case key of
      'a'..'z','A'..'Z','1'..'9','0',' ','(',')':
         if i<10 then begin
            inc(i);
            ch[i]:=key;
         end;
      '-','+','*','/':if i>0 then dec(i);
     end;
   until (key=enter);
   lastN:=i;
   str1:='';
   for j:=1 to i do str1:=str1+ch[j];
    if str1='' then str1:='Incognito';
   hi[21].names:=str1;
   sortScores;
   rewrite(f1);
     write(f1,hi);
     close(f1);
   showScores;
 end;
end;
{-----------------------------------------------------------------}
BEGIN
new(map);
new(v);
new(r);
Tables;
assign(f1,'scores1.lab');
SetGraficMode(2);
for i:=1 to 63 do setRgbPalette(    i,i,i,i);
for i:=0 to 63 do setRgbPalette( 64+i,0,i,0);
for i:=1 to 63 do setRgbPalette(127+i,i,i,0);
SetRGBPalette(255, 0,40, 0);
SetRGBPalette(254,63,20,20);
SetRGBPalette(253,11,11,35);


{$i-}
reset(f1);
{$i+}
if ioresult<>0 then
eraseScores
else begin
 read(f1,hi);
  close(f1);
end;

lasthi:=0;
newGame1:=true;
repeat
if newGame1=true then newGame;

drawMap;
if show=true then showScores;
m.drawMe;
key:=readKey;
with m do
case key of
  f10  :ext:=true;
  f5   :hide1:=not hide1;
  f2   :if g>=ExplCost then begin
          flg:=false;

          for i:=-1 to 1 do
            for j:=-1 to 1 do if (x+j>0) and (x+j<=MaxX) and (y+i>0) and (y+i<=MaxY) then begin
              r^[x+j,y+i]:=1;
              if map^[x+j,y+i]=1 then begin
                map^[x+j,y+i]:=2;
                Flg:=true
              end;
            end;
         if flg=true then begin
          dec(g,explCost);
          if explose=true then begin
           for i:=1 to 63 do begin
             for j:=1 to i do begin
               setColor(190-j);
               circle((x-1)*sz+sz div 2-1,(y-1)*sz+sz div 2-1,j div 6);
             end;
             setColor(189);
             for j:=1 to (1+i div 9) do
                              line((x-1)*sz+sz div 2-1,(y-1)*sz+sz div 2-1,
                                   (x-1)*sz+sz div 2-1+round((random*3*sz-1.5*sz)*(i/64)),
                                   (y-1)*sz+sz div 2-1+round((random*3*sz-1.5*sz)*(i/64)));
{             delay(5);}
           end;
          end;
         end;
        end;
  up   :moveMe( 0,-1);
  down :moveMe( 0,+1);
  left :moveMe(-1, 0);
  right:moveMe(+1, 0);
    'q':NewGame1:=true;
end;
m.lookAround;
if (newGame1=true) or (ext=true) then lookScore;
until ext=true;

dispose(map);
dispose(v);
dispose(r);
restoreCrtMode;
CloseGraph
END.