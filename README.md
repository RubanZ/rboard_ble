# rboard_ble

Построение нативного интерфейса для управления по Bluetooth Low Energy.

## Оглавление
0. [Описание](#Описание)
1. [Скриншоты](#Скриншоты)
2. [Что работает?](#Что-работает?)
3. [Как с этим работать?](#Как-с-этим-работать?)
4. [Пример кода для ESP32](#Пример-кода-для-ESP32)
5. [Использованно при создании](#Использованно-при-создании)


## Описание

Данный проект сделан на Flutter и позволяет построить интерфейс управления на телефоне используя записанные на устройстве* параметры.

Протестированно на ESP32 с Android

ВНИМАНИЕ! minSdkVersion >= 19
## Скриншоты
[:arrow_up:Оглавление](#Оглавление)

Тут картинки

## Что работает?
[:arrow_up:Оглавление](#Оглавление)
На данный момент планы такие:  
:white_check_mark: Загрузка интерфейса из микроконтроллера     
:black_square_button: Управляющие команды    
:black_square_button: OTA update firmware   

## Как с этим работать?
[:arrow_up:Оглавление](#Оглавление)
| Обозначение в МК | Описание | UUID|
|----:|:----:|:----------|
| CMD_SERVICE_UUID | UUID командного сервиса  | 334afad7-9712-48fb-aae9-2404ad83fe3f |
| APP_SERVICE_UUID | UUID сервиса, содержащего интерфейс  | 334afad7-9712-48fb-aae9-000000000000 |
| SETTINGS_UUID | Характеристика команды  | - |
| APP_UUID | Характеристика передачи интерфейса  | - |


## Пример кода для ESP32
[:arrow_up:Оглавление](#Оглавление)


```C++
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define CMD_SERVICE_UUID "334afad7-9712-48fb-aae9-2404ad83fe3f"
#define APP_SERVICE_UUID "334afad7-9712-48fb-aae9-000000000000"

#define SETTINGS_UUID "2cbd3d41-390a-4b07-8ad1-b1de2d88b511"
#define APP_UUID "2cbd3d41-390a-4b07-8ad1-b1de2d88b500"

void BLEAppCallbacks::onWrite(BLECharacteristic *Characteristic)
{
    std::string value = Characteristic->getValue();

    if (value.length() > 0)
    {
        Serial.println(value.c_str());
    }
}
void BLEAppCallbacks::onRead(BLECharacteristic *Characteristic)
{
    std::string buffer = "";
    uint16_t countPacket = floor(app.size() / 20);
    byte packet[2];
    for (int i = 0; i < 2; i++)
        packet[1 - i] = (countPacket >> (i * 8));
    Serial.print("cout packet: "); Serial.println(countPacket);
    buffer += char(packet[0]);buffer += char(packet[1]);
    for (uint16_t i = this->package*20; i < this->package*20+20; i++){
        if (i < this->app.size())
            buffer+=this->app[i];
        else
            break;
    }
    this->package += 1;
    Serial.println("send BLE");
    Serial.println(ESP.getFreeHeap());
    Characteristic->setValue(buffer);
}

class BLEAppCallbacks : public BLECharacteristicCallbacks
{
    void onWrite(BLECharacteristic *Characteristic);
    void onRead(BLECharacteristic *Characteristic);

    uint16_t package = 0;
    std::string app = "{\"type\":\"Row\",\"crossAxisAlignment\":\"start\",\"mainAxisAlignment\":\"start\",\"mainAxisSize\":\"max\",\"textBaseline\":\"alphabetic\",\"textDirection\":\"ltr\",\"verticalDirection\":\"down\",\"children\":[{\"type\":\"Text\",\"data\":\"Flutter\"},{\"type\":\"RaisedButton\",\"color\":\"##FF00FF\",\"padding\":\"8,8,8,8\",\"textColor\":\"#00FF00\",\"elevation\":8,\"splashColor\":\"#00FF00\",\"child\":{\"type\":\"Text\",\"data\":\"Widget\"}},{\"type\":\"Text\",\"data\":\"Demo\"},{\"type\":\"RaisedButton\",\"color\":\"##FF00FF\",\"padding\":\"8,8,8,8\",\"textColor\":\"#00FF00\",\"elevation\":8,\"splashColor\":\"#00FF00\",\"click_event\":\"route:list\",\"child\":{\"type\":\"Text\",\"data\":\"Go to\"}}]}";
};

void setup() {
    Serial.begin(115200);
    BLEDevice::init("NAME_DEVICE");
    BLEServer *appServer = BLEDevice::createServer();

    BLEService *cmdService = appServer->createService(CMD_SERVICE_UUID);
    BLEService *appService = appServer->createService(APP_SERVICE_UUID);

    this->SettingsCharacteristic = cmdService->createCharacteristic(
        SETTINGS_UUID,
        BLECharacteristic::PROPERTY_READ |
            BLECharacteristic::PROPERTY_WRITE);

    this->AppCharacteristic = appService->createCharacteristic(
        APP_UUID,
        BLECharacteristic::PROPERTY_READ |
            BLECharacteristic::PROPERTY_WRITE);

    this->AppCharacteristic->setCallbacks(&AppCallbacks);
    this->AppCharacteristic->addDescriptor(new BLE2902());

    this->SettingsCharacteristic->setValue("true122211");
    //this->AppCharacteristic->setValue(this->app);

    cmdService->start();
    appService->start();


    appServer->getAdvertising()->start();
}

void loop() {}
```

## Использованно при создании
[:arrow_up:Оглавление](#Оглавление)

Ниже список пакетов, с опиманием их предназначения 
| Пакет | Описание | 
|----:|:----|
| [dynamic_widget](https://github.com/dengyin2000/dynamic_widget) | Построение динамического интерфейса  | 
| [rx_ble](https://github.com/scientifichackers/flutter-rx-ble) | Коммуникация с BLE  | 