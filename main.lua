--[[
    todo list:
    OPTIMIZATION:

--]]

function love.load()
    GAME_STATE = "menu"
    GAME_MODE = "none"
    GAME_HEIGHT = love.graphics.getHeight()
    GAME_WIDTH = love.graphics.getWidth()
    CELL_SCALE = 4
    CELL_SIZE = 2^CELL_SCALE --must be a number like 2^n
    x = 0
    y = 0
    COLS = (GAME_WIDTH - CELL_SIZE) / CELL_SIZE
    ROWS = COLS
    love.graphics.setFont(love.graphics.newFont("Perfect DOS VGA 437.ttf", 32))
    DISPLAY_TEXT = "PRESS (R) TO RESET, (M) TO MENU"

    -- Generate 2d Array
    board = {}
    for i=0,ROWS do
        board[i] = {}
        for j=0,COLS do
            board[i][j] = 1
        end
    end
end

function love.update(dt)
    if GAME_STATE == "running" then
        game_loop()
        love.timer.sleep(0.125)
    end
end

function love.draw()
    if GAME_STATE == "menu" then
        --Display menu
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("LUA Conway's Game Of Life", 90, 240)
        love.graphics.print("Press (S) for random cells", 50, 400)
        love.graphics.print("Press (G) for a glider", 50, 428)
        love.graphics.print("Press (Q) to quit", 50, 456)
    end

    if GAME_STATE == "running" then
        for i=0,ROWS do
            for j=0,COLS do
                --Select black if cell = 0 else select white
                if board[i][j] == 0 then love.graphics.setColor(0, 0, 0)
                else love.graphics.setColor(255, 255, 255) end

                --Display cell
                love.graphics.rectangle("fill", CELL_SIZE*j, CELL_SIZE*i, CELL_SIZE, CELL_SIZE)
            end
        end

        --Display bottom text
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(DISPLAY_TEXT, 5, 640)
        love.graphics.print("ALIVE CELLS: " .. ALIVE_CELLS, 5, 668)
    end
end

function love.keypressed(key)
    --In menu
    if GAME_STATE == "menu" then
        if key == "s" then
            GAME_STATE = "running"
            GAME_MODE = "random"
            reset(GAME_MODE)
        end
        if key == "g" then
            GAME_STATE = "running"
            GAME_MODE = "glider"
            reset(GAME_MODE)
        end
        if key == "q" then
            love.event.quit()
        end
    end

    --In game
    if GAME_STATE == "running" then
        if key == "r" then
            reset(GAME_MODE)
        end
        if key == "m" then
            GAME_STATE = "menu"
            GAME_MODE = "none"
        end
    end
end

-- #############################################################################################################################--
--main game loop
function game_loop()
    tempBoard = {}
    for i=0,ROWS do
        tempBoard[i] = {}
        for j=0,COLS do
            tempBoard[i][j] = 1
        end
    end
    verifCell(board, tempBoard)
    for i=0,ROWS do
        for j=0,COLS do
            board[i][j] = tempBoard[i][j]
        end
    end
end

--[[
    CREATING & RESETING GRID====================================================
]]--
--gen random grid
function random_grid_gen()
    for i=1, ROWS-1 do
        for j=1, COLS-1 do
            board[i][j] = math.floor(math.random(0, 5))
        end
    end
end

--reset function regarding GAME_MODE
function reset(gamemode)
    if gamemode == "glider" then
        for i=0,ROWS do
            for j=0,COLS do
                board[i][j] = 1
            end
        end
        board[1][2] = 0
        board[2][3] = 0
        board[3][1] = 0
        board[3][2] = 0
        board[3][3] = 0
    end
    if gamemode == "random" then
        for i=0,ROWS do
            for j=0,COLS do
                board[i][j] = 1
            end
        end
        random_grid_gen()
    end
end


--[[
    CELL CHECKS=================================================================
]]--
--count alive cells
function verifCell(board, tempBoard)
    ALIVE_CELLS = 0
    for i=1, ROWS-1 do
        for j=1, COLS-1 do
            verifNeighbors(board, i, j, tempBoard)
            if board[i][j] == 0 then ALIVE_CELLS = ALIVE_CELLS + 1 end
        end
    end
end

--check cell's neighbors
function verifNeighbors(board, i, j, tempBoard)
    neighbors = 0 -- Reset neighbors count

    -- Count the neighbors around the cells
    for x=i-1, i+1 do
        for y=j-1, j+1 do
            if board[x][y] == 0 then
                neighbors = neighbors+1
            end
        end
    end
    if board[i][j] == 0 then neighbors = neighbors-1 end --remove center cell if alive

    -- Determine if one shall live or not
    if neighbors == 3 and board[i][j] == 1 then
        tempBoard[i][j] = 0
    elseif (neighbors == 2 or neighbors == 3) and board[i][j] == 0 then
        tempBoard[i][j] = 0
    else
        tempBoard[i][j] = 1
    end
end
