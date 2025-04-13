local focal = peripheral.find("focal_link")

while true do
    if focal.remainingIotaCount() ~= 0 then
        print(focal.reciveIota())
    end
end