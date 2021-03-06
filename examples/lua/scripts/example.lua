-- yasio 3.35 demo
local proto = require 'protocol_enc'
local yasio = require 'yasio' -- constants

local obsnew = yasio.fast_obstream.new()
obsnew:write_v("hello")
obsnew:write_f16(9.3)

local ibsnew = yasio.fast_ibstream.new(obsnew)
local strval = ibsnew:read_v()
local f16val = ibsnew:read_f16()
print('yasio - f16val=' .. f16val)

local io_service = yasio.io_service
local stopFlag = 0

local hostent = {host = '0.0.0.0', port = 12191}
local hostents = {
    {host = '0.0.0.0', port = 12191},
    {host = '0.0.0.0', port = 12192}
}

local server = io_service.new(hostents)

local transport1 = nil
local data_partial2 = nil
local packet_count = 0
server:start(function(event)
        local t = event:kind()
        if t == yasio.YEK_PACKET then
            packet_count = packet_count + 1
        elseif(t == yasio.YEK_CONNECT_RESPONSE) then -- connect responseType
            if(event:status() == 0) then
                local transport = event:transport()
                -- local requestData = "GET /index.htm HTTP/1.1\r\nHost: www.ip138.com\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36\r\nAccept: */*;q=0.8\r\nConnection: Close\r\n\r\n"
                local msg = {
                    id = 110,
                    value1 = 3291,
                    value2 = 391040,
                    value3 = true,
                    value4 = 301.32,
                    value6 = 13883.197,
                    uname = "halx99",
                    passwd = "x-studio Pro is a powerful IDE!"
                }
                local obs = proto.e101(msg)
   
                -- separate packet to 2 partial
                local data = obs:to_string()
                local data_partial1 = data:sub(1, #data - 10)
                
                data_partial2 = data:sub(#data - 10 + 1, #data)
                
                -- write the whole packet
                print('yasio - write whole packet with yasio::obstream*')
                server:write(transport, obs)
                
                -- write the partial1
                server:write(transport, data_partial1)
                
                -- write the partial2 after 3 seconds
                transport1 = transport
                print('yasio - the remain data will be sent after 3 seconds...')
            end
        elseif(t == yasio.YEK_CONNECTION_LOST) then -- connection lost event
            print("yasio - the connection is lost!")
        end
    end)
 
-- enable reuse addr for tcp server    
server:set_option(yasio.YOPT_C_MOD_FLAGS, 0, yasio.YCF_REUSEADDR, 0)
server:set_option(yasio.YOPT_C_MOD_FLAGS, 1, yasio.YCF_REUSEADDR, 0)

server:open(0, yasio.YCK_TCP_SERVER)
server:open(1, yasio.YCK_TCP_SERVER)

hostent.host = "127.0.0.1"
local client = io_service.new(hostent)

--tcp unpack params, TCP????????????????????????:
client:set_option(yasio.YOPT_C_LFBFD_PARAMS,
    0, -- channelIndex, ????????????    
    65535, -- maxFrameLength, ???????????????
    0,  -- lenghtFieldOffset, ?????????????????????????????????????????????
    4, -- lengthFieldLength, ???????????????????????????1?????????2?????????3?????????4??????
    0 -- lengthAdjustment??????????????????????????????????????????????????????0??? ???????????????=????????????
)

client:start(function(event)
        local t = event:kind()
        if t == yasio.YEK_PACKET then
            local ibs = event:packet()
            local msg = proto.d101(ibs)
            print(string.format('yasio - receve data from server: %s', msg.passwd))
            stopFlag = stopFlag + 1
            -- test buffer out_of_range exception handler
            local _, result = pcall(ibs.read_i8, ibs)
            print('yasio - ' .. result)
        elseif(t == yasio.YEK_CONNECT_RESPONSE) then -- connect responseType
            if(event:status() == 0) then
                print("yasio - connect server succeed.")
                -- local transport = event:transport()
                -- local requestData = "GET /index.htm HTTP/1.1\r\nHost: www.ip138.com\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36\r\nAccept: */*;q=0.8\r\nConnection: Close\r\n\r\n"
                -- client:write(transport, obs)
            else
                print("yasio - connect server failed!")
            end
        elseif(t == yasio.YEK_CONNECTION_LOST) then -- connection lost event
            print("yasio - the connection is lost!")
        end
    end)

-- httpclient 
local http_client = require 'http_client'
local start = yasio.highp_clock() / 1000 -- (ms)
http_client:sendHttpGetRequest('http://tool.chinaz.com/', function(respData)
    print(string.format('yasio - http request done, %d bytes transferred, time cost=%f(ms)\n', #respData, (yasio.highp_clock() / 1000) - start))
    print(respData)
    stopFlag = stopFlag + 1
end)

local elapsedTime = 0
local partial2Sent = false
local connectRequested = false

local function yasio_update(dt)  
    elapsedTime = elapsedTime + dt

    server:dispatch(128)
    client:dispatch(128)
    if http_client then
        http_client:update()
    end

    if elapsedTime > 2 and not connectRequested then
        connectRequested = true
        print('yasio - connecting server...')
        client:open(0, yasio.YCK_TCP_CLIENT)
    end
    if elapsedTime > 3 and not partial2Sent then
        partial2Sent = true
        if transport1 then
            server:write(transport1, data_partial2)
        end
    end
    return stopFlag >= 3
end

if(yasio.loop) then
    print("yasio - start loop main thread to fetch event from yasio io_service!")
    yasio.loop(-1, 0.02, function()
            yasio_update(0.02)
        end)
end

return yasio_update
