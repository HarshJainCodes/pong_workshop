WINDOW_WIDTH = 1000
WINDOW_HEIGHT = 500

Class = require 'class' -- require class so as to be able to do OOP

Paddle = Class{} -- we create a paddle class

function Paddle:init(x, y, width, height) -- the init method of paddle class
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 200
end

Ball = Class{} -- we create a ball class

function Ball:init(x, y, width, height) -- the init method of ball class
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.xspeed = 0 -- hard coded for now but we can randomise
    self.yspeed = 0
end

function collison(k, v)
    return k.x + k.width > v.x and
            k.x < v.x + v.width and
            k.y + k.height > v.y and
            k.y < v.y + v.height
end

function love.keypressed(key)
    if key == "space" and state == "steady" then
        state = "play"
        if math.random(1, 2) == 1 then
            ball.xspeed = math.random(250, 450)
            if math.random(1, 2) == 1 then
                ball.yspeed = math.random(350, 600)
            else
                ball.yspeed = -math.random(350, 600)
            end
        else
            ball.xspeed = -math.random(250, 450)
            if math.random(1, 2) == 1 then
                ball.yspeed = math.random(350, 600)
            else
                ball.yspeed = -math.random(350, 600)
            end
        end
    end
end

--updates the ball
function Ball:update(dt)
   self.x = self.x + self.xspeed * dt
   self.y = self.y + self.yspeed * dt

   -- check if the ball touches the lower wall
   if self.y > WINDOW_HEIGHT - self.height then
       self.yspeed = -self.yspeed
       self.y = WINDOW_HEIGHT - self.height  -- to avoid glitch
   end
   -- check if the ball touches the upper ball
   if self.y < 0 then
       self.yspeed = -self.yspeed
       self.y = 0  -- to avoid glitch
   end

   -- check if the ball collides with the left paddle
   if collison(ball, left_paddle) then
       ball.xspeed = -ball.xspeed * 1.1
       ball.x = left_paddle.width -- to prevent any glitches
   end

   -- check if the ball collides with the right paddle
   if collison(ball, right_paddle) then
       ball.xspeed = -ball.xspeed * 1.1
       ball.x = WINDOW_WIDTH - right_paddle.width - ball.width -- to prevent any glitches
   end

   if self.x > WINDOW_WIDTH then
        player1_score = player1_score + 1
        self.x = WINDOW_WIDTH/2 - self.width/2
        self.y = WINDOW_HEIGHT/2 - self.height/2
        turn = 2
        self.xspeed = -math.random(250, 350)
        if math.random(1, 2) == 1 then
            self.yspeed = math.random(250, 350)
        else
            self.yspeed = -math.random(200, 600)
        end
    elseif self.x < -self.width then
        player2_score = player2_score + 1
        self.x = WINDOW_WIDTH/2 - self.width/2
        self.y = WINDOW_HEIGHT/2 - self.height/2
        turn = 1
        self.xspeed = math.random(250, 350)
        if math.random(1, 2) == 1 then
            self.yspeed = math.random(250, 350)
        else
            self.yspeed = -math.random(200, 600)
        end
   end
end

-- will draw the ball
function Ball:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


function love.load()
    math.randomseed(os.time())
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- create the left and right paddle objects
    left_paddle = Paddle(0, WINDOW_HEIGHT/2 - 100/2, 20, 100)
    right_paddle = Paddle(WINDOW_WIDTH - 20, WINDOW_HEIGHT/2 - 100/2, 20, 100)

    -- create the ball object
    ball = Ball(WINDOW_WIDTH/2 - 5, WINDOW_HEIGHT/2 - 5, 10, 10)

    player1_score = 0
    player2_score = 0

    turn = 1
    state = "steady"
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        left_paddle.y = math.max(0, left_paddle.y - left_paddle.speed * dt) 
        -- math.max is used so that the paddle dosnt go out of the screen
    end
    if love.keyboard.isDown("s") then
        left_paddle.y = math.min(WINDOW_HEIGHT - left_paddle.height, left_paddle.y + left_paddle.speed * dt)
        -- math.min is used so that the paddle dosnt go out of the screen
    end
    if love.keyboard.isDown("up") then
        right_paddle.y = math.max(0, right_paddle.y - right_paddle.speed * dt)
    end
    if love.keyboard.isDown("down") then
        right_paddle.y = math.min(WINDOW_HEIGHT - right_paddle.height, right_paddle.y + right_paddle.speed * dt)
    end
    -- update the ball by calling the update method of the ball object
    ball:update(dt)
end

function love.draw()
    love.graphics.setFont(love.graphics.newFont(30))
    if state == "steady" then
        love.graphics.printf("press space to start the game", 0, WINDOW_HEIGHT/2 + 100, WINDOW_WIDTH, "center")
        love.graphics.rectangle("fill", left_paddle.x, left_paddle.y, left_paddle.width, left_paddle.height)
        love.graphics.rectangle("fill", right_paddle.x, right_paddle.y, right_paddle.width, right_paddle.height)

        ball:draw()
    else
        love.graphics.rectangle("fill", left_paddle.x, left_paddle.y, left_paddle.width, left_paddle.height)
        love.graphics.rectangle("fill", right_paddle.x, right_paddle.y, right_paddle.width, right_paddle.height)

        -- draw the ball using the draw method of the ball object

        
        love.graphics.printf(tostring(player1_score), 200, 100, 100, "center")
        love.graphics.printf(tostring(player2_score), 800, 100, 100, "center")
        ball:draw()
    end


    
end