{$R+}
{$N+}
{$Q-}
{$S-}
Program Labyrint;
uses Crt,Graph,StLib;

const hide=false;
      explored=true;

type mapArray=array[1..128,1..96] of byte;
type man=object
 x,y:byte;
 g:word;
 vr:byte;
 Procedure DrawMe;
 Procedure MoveMe(mx,my:shortInt);
 Procedure LookAround;
end;

var m:man;
    r,v,map:^MapArray;
    MaxX,MaxY,sz:byte;
    sn,cs:array[0..89] of real;
    ext:boolean;
    x1,y1:integer;
    str1,str2,str3,StrFile:string;
    lk:word;
    newGame1:boolean;
    hide1:boolean;
    extra:boolean;

    edit:boolean;
    fl1:file of MapArray;
    fl2:file of MapArray;

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
 if ((map^[x1,y1]<>1) and (map^[x1,y1]<>3)) or (edit=true) then begin
  if edit=false then V^[m.x,m.y]:=vr+1;
  R^[m.x,m.y]:=1;
  inc(x,mx);
  inc(y,my);
  R^[m.x,m.y]:=1;
 end;
end;
end;
{-----------------------------------------------------------------}
Procedure man.DrawMe;
begin
setFillStyle(1,254);
if extra=true then begin
  x1:=320;
  y1:=240;
end else begin
  x1:=(x-1)*sz;
  y1:=(y-1)*sz;
end;
bar(x1,y1,x1+sz-1,y1+sz-1);
end;
{-----------------------------------------------------------------}
Procedure man.LookAround;
begin
 if (hide1=true) and (edit=false) then
 for i:=1 to maxY do
   for j:=1 to MaxX do if v^[j,i]>0 then begin
     dec(V^[j,i]);
     R^[j,i]:=1;
 end;
 if edit=true then
 for i:=1 to maxY do
   for j:=1 to MaxX do if V^[j,i]<>vr then begin
     V^[j,i]:=vr;
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
hide1:=false;
newGame1:=false;
randomize;
MaxX:=128;
MaxY:=96;
extra:=false;
Edit:=false;
sz:=5;
m.x:=MaxX div 2;
m.y:=MaxY;
m.g:=30;
m.vr:=11;

str1:='c:\tp7\programs\lab\'+strFile+'.sav';
assign(fl2,str1);
str1:='c:\tp7\programs\lab\'+strFile+'.lab';
assign(fl1,str1);
reset(fl1);
 read(fl1,Map^);
close(fl1);

for i:=1 to MaxY do
  for j:=1 to maxX do begin
    v^[j,i]:=0;
    r^[j,i]:=1;
    if map^[j,i]=255 then begin
      m.x:=j;
      m.y:=i;
    end;
  end;

{map^[m.x,m.y]:=0;}
V^[m.x,m.y]:=m.vr+1;
m.lookAround;
ext:=false;
end;
{-----------------------------------------------------------------}
procedure drawMap;
begin
 if extra=true then begin
 setFillStyle(1,0);
 for i:=-m.vr to m.vr do
   for j:=-m.vr to m.vr do begin
     flg:=false;
     x1:=(m.x+j);
     y1:=(m.y+i);
     if (x1<=MaxX) and (x1>=1) and (y1<=maxY) and (y1>=1) then begin
       r^[x1,y1]:=1;
       flg:=true;
     end;
     if flg=false then begin
       x1:=j*sz+320;
       y1:=i*sz+240;
       bar(x1,y1,x1+sz-1,y1+sz-1);
     end;
 end;
 end;

lk:=0;
for i:=1 to MaxY do
  for j:=1 to maxX do if r^[j,i]>0 then begin
    r^[j,i]:=0;
    if extra=true then begin
      x1:=(j-m.x)*sz+320;
      y1:=(i-m.y)*sz+240;
    end else begin
      x1:=(j-1)*sz;
      y1:=(i-1)*sz;
    end;
    case map^[j,i] of
      1:setFillStyle(1,V^[j,i]*5);
    0,2,255:setFillStyle(1,V^[j,i]*2);
      3:setFillStyle(9,V^[j,i]*5);
    end;
    if (V^[j,i]=m.vr+1) and (explored=true) then setFillStyle(1,253);
    bar(x1,y1,x1+sz-1,y1+sz-1);
    if map^[j,i]=2 then begin
      setColor(64+round(sqr(V^[j,i]/1.4)));
      for i:=1 to sz div 2 do
        circle(x1+sz div 2,y1+sz div 2,i);
    end;

    setColor(round(V^[j,i]*5.2));
    if j=maxX then line(x1+sz-1,y1     ,x1+sz-1,y1+sz-1);
    if i=maxY then line(x1     ,y1+sz-1,x1+sz-1,y1+sz-1);
    if j=1    then line(x1     ,y1     ,x1     ,y1+sz-1);
    if i=1    then line(x1     ,y1     ,x1+sz-1,y1     );
  end;

for i:=1 to MaxY do
  for j:=1 to maxX do if v^[j,i]>0 then inc(lk);
{SetFillStyle(1,0);
bar(500,10,640,30);
setColor(63);
str(lk:5,str1);
str(100*(lk/(maxX*maxY)):5:2,str2);
ouTTextXY(501,11,'S'+str1+'('+str2+'%)');}

{str(m.g:4,str1);
str(m.Vr:2,str2);
ouTTextXY(501,21,'G'+str1);}
end;
{-----------------------------------------------------------------}
procedure NewMap;
begin
str1:='c:\tp7\programs\lab\'+strFile+'.lab';
assign(fl1,str1);
rewrite(fl1);
  write(fl1,Map^);
  close(fl1);
end;
{-----------------------------------------------------------------}
BEGIN
new(map);
new(v);
new(r);
Tables;
SetGraficMode(2);
for i:=1 to 63 do setRgbPalette(    i,i,i,i);
for i:=0 to 63 do setRgbPalette( 64+i,0,i,0);
for i:=1 to 63 do setRgbPalette(127+i,i,i,0);
SetRGBPalette(255, 0,40, 0);
SetRGBPalette(254,63,20,20);
SetRGBPalette(253,11,11,35);


strFile:='2';
newGame1:=true;
repeat
{for i:=1 to MaxY do
  for j:=1 to maxX do
    Map^[j,i]:=0;
newMap;}
  if newGame1=true then newGame;
  drawMap;
  m.drawMe;
  key:=readKey;
 with m do begin
  case key of
    f10  :ext:=true;
    f3   :hide1:=not hide1;
    f2   :begin
            extra:=not extra;
            clearViewPort;
          end;
{    '+'  :begin
           key:=readKey;
           if key='s' then begin
             rewrite(fl2);
               write(fl2,Map^);
             close(fl2);
           end;
          end;
    '-'  :begin
           key:=readKey;
           if key='r' then begin
             reset(fl2);
               read(fl2,Map^);
             close(fl2);
           end;
          end;}
    up   :moveMe( 0,-1);
    down :moveMe( 0,+1);
    left :moveMe(-1, 0);
    right:moveMe(+1, 0);
    'q'  :NewGame1:=true;
    f1   :if strFile='3' then edit:=not edit;

  end;
  if (edit=true) then begin
    l:=-1;
    case key of
      '0':l:=0;
      '1':l:=1;
      '2':l:=2;
      '3':l:=3;
      '^':l:=255;
      's':begin
           rewrite(fl1);
             write(fl1,Map^);
             close(fl1);
          end;
    end;
    if l>-1 then begin
      map^[x,y]:=l;
      r^[x,y]:=1;
    end;
  end;
 end;
  m.lookAround;
until ext=true;

dispose(map);
dispose(v);
dispose(r);
restoreCrtMode;
CloseGraph
END.