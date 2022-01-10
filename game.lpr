program game;

{$mode objfpc}{$H+}

uses 
raylib, math;

const
  screenWidth = 1024;
  screenHeight = 600;
  SnowflakeCount = 300;

type
  // TSnowflake - структура снежинки
  TSnowflake = record
    X: Single;// координата X
    Y: Single;// координата Y
    Speed: Single;// скорость падения
    Size: Integer;// размер
    Time: Single;// локальное время
    TimeDelta: Single;// дельта изменения времени
  end;


var
  // массив снежинок
  Snow: array [0..SnowflakeCount - 1] of TSnowflake;
  X, Y: Integer;
  Size: Integer;
  I: Integer;
  DeltaX, t: Single;
  BgImg: TImage;
  BgTx: TTexture2d;

function MakeSnowflake: TSnowflake;
const
  MaxSpeed = 5;
  MaxSize = 7;
  Bounds = 30;
  MaxTimeDelta = 0.0015;
begin
  // задаем случайную координату по X
  Result.X := RandomRange(-Bounds, screenWidth + Bounds);
  // обнуляем Y
  Result.Y := -MaxSize;
  // задаем случайную скорость падения
  Result.Speed := 0.5 + Random * MaxSpeed;
  // задаем случайный размер
  Result.Size := RandomRange(2, MaxSize);
  // задем время
  Result.Time := Random * 2 * Pi;
  // задаем величину приращивания времени
  Result.TimeDelta := Random * MaxTimeDelta;
end;

// MakeSnow - создает снежинки
procedure MakeSnow;
var
  I: Integer;
begin
  for I := 0 to High(Snow) do
    Snow[I] := MakeSnowflake;
end;

procedure UpdateSnow;
var
  I: Integer;
begin
  for I := 0 to High(Snow) do
  begin
    // приращиваем координату по Y
    Snow[I].Y := Snow[I].Y + Snow[I].Speed;
    // увеличиваем время
    Snow[I].Time := Snow[I].Time + Snow[I].TimeDelta;
    // пересоздаем снежинку, если она упала за границы формы
    if Snow[I].Y > screenHeight then
      Snow[I] := MakeSnowflake;
  end;
end;


begin
  // Initialization
  //--------------------------------------------------------------------------------------
  InitWindow(screenWidth, screenHeight, 'raylib - simple project');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  // создаем снег
  MakeSnow;
  // Load Image
  BgImg:=LoadImage('snow.png'); // Load image in CPU memory (RAM)
  //Resize Image
  ImageResize(@BgImg,screenWidth, screenHeight);
  // Image converted to texture, uploaded to GPU memory (VRAM)
  BgTx:=LoadTextureFromImage(BgImg);
  // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
  UnloadImage(BgImg);


  //--------------------------------------------------------------------------------------
  // Main game loop
  while not WindowShouldClose() do
    begin
      // Update
      //----------------------------------------------------------------------------------
      // обновлаяем снег
      UpdateSnow;
      // Draw
      //----------------------------------------------------------------------------------
      BeginDrawing();
        ClearBackground(BLACK);
        DrawTexture(bgTx,0,0,White);

        // рисуем снежинки
        for I := 0 to High(Snow) do
  begin
    // получаем размер
    Size := Snow[I].Size;
    t := Snow[I].Time;
    // вычисляем смещение
    DeltaX := Sin(t * 27) + Sin(t * 21.3) + 3 * Sin(t * 18.75) +
      7 * Sin(t * 7.6) + 10 * Sin(t * 5.23);
    DeltaX := DeltaX * 10;
    // получаем X
    X := Trunc(Snow[I].X + DeltaX);
    // получаем Y
    Y := Trunc(Snow[I].Y);
    // рисуем круг по координатам X, Y, с диаметром Size
    DrawCircle(X,Y,Size,ColorCreate(255,251,240,220));
  end;



        DrawText('background by Prusakov Vitaly', 20, screenHeight-20, 10, GREEN);
      EndDrawing();
    end;
  // De-Initialization
  //--------------------------------------------------------------------------------------
  CloseWindow();        // Close window and OpenGL context
  //--------------------------------------------------------------------------------------
end.

