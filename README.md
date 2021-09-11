# Mqtt-Falcon

# (Application Structure)

**General Structure Tree:**

![](RackMultipart20210911-4-hobine_html_f54c8b785b3b1e76.gif)

Main page:

![](RackMultipart20210911-4-hobine_html_e31a0a57d43f5df7.gif) ![](RackMultipart20210911-4-hobine_html_ce405e01b3d471f3.gif) ![](RackMultipart20210911-4-hobine_html_931654cff1d3c53a.gif) ![](RackMultipart20210911-4-hobine_html_cd5f5d9c4cf70cc5.gif) ![](RackMultipart20210911-4-hobine_html_59cf861547301a81.gif)

Setting page : For broker connection

AppDrawer

![](RackMultipart20210911-4-hobine_html_28e790d976df221c.gif)

 ![](RackMultipart20210911-4-hobine_html_707265c0d518e24b.gif)
1.

![](RackMultipart20210911-4-hobine_html_90f3a71f92487d6.gif) ![](RackMultipart20210911-4-hobine_html_91ea0c9dfe9f120c.gif) ![](RackMultipart20210911-4-hobine_html_56731f3cbea38d31.gif)

connection cards list

1.) Dashboard

2.) Main page

3.) Message page(Adv)

4.) Light 0n/off

5.Loggings

Set Broker Page :

1.Normal mqtt

2.Mqtt over SSl/Tls

3.Ws/Wss

 (B)

(C)

(Note : Work flow of all the features of each Tree node is mentioned in detail below with the Snapshots of Widgets)

**A .) Main page** : This page is the main page when the app starts it generally routs this page first .

![](RackMultipart20210911-4-hobine_html_6a8466da29d0178e.gif)

**Main page :**

![](RackMultipart20210911-4-hobine_html_4a36a0d394636ef8.jpg) ![](RackMultipart20210911-4-hobine_html_486e993dc94b930f.jpg)

Feature 1) It contains the list of brokers With same configuration details that user have saved or connected .

Feature 2) On Tapping on card will Provide user automatic connection to the broker with the preferable configuration.

Feature 3) On Long pressing the card will provide the functionality to update the configuration of connection including Username and Password and Can delete the card

**Setting Page:**

This button will lead the user to the **Set Broker** page . To know more please refer State (B)

App Drawer:

User can access it by taping on button or by sliding finger left to right. TO know more please refer State (C)

**( B .) Setting page** :

T ![](RackMultipart20210911-4-hobine_html_e499386a694d8bfa.jpg) his page is to Set Broker connection configurations with numerous option of secured protocols .

![](RackMultipart20210911-4-hobine_html_fae3b0eb1adc6d80.jpg)

Feature 1): This configuration form consist of following inputs .

Feature 2): user manually can select Protocol to connect and send messages over that protocol.

Feature 3): By pressing the connect button the configurations that are provided will be save it database.which later will be shown on main page as a card with connection functionality.

**( C .) App Drawer:**

This drawer contains different page routs with different functionalities.

![](RackMultipart20210911-4-hobine_html_9f7757216868d511.jpg)

**1.) Dashboard:**

Feature 1) It contains the list of Rooms and Devices With same configuration details that user have prvided.

Feature 2) On Long pressing the card will provide the functionality to update the configuration including Title ,Topic, reatain and qos and Can delete the card

Feature 3) On Tapping on card of room or device will lead the user to the controller page of room or device. ![](RackMultipart20210911-4-hobine_html_b7ee122836277c3f.jpg) ![](RackMultipart20210911-4-hobine_html_fcac9585c616136d.jpg)

![](RackMultipart20210911-4-hobine_html_731c4977d76b8ec3.jpg) ![](RackMultipart20210911-4-hobine_html_946b753fd789d0de.jpg)

![](RackMultipart20210911-4-hobine_html_190944472d8a8eab.gif)

**Rooms :**

It contains several device options with different control features to control devices cames under the room.

Feature 1) On Long pressing the card will provide the functionality to update the configuration including Title ,Topic and Can delete the card

Feature 3) user can turn on /off ,can choose modes to set , can change Temperature in deg C or deg F

![](RackMultipart20210911-4-hobine_html_27a5b2ef2a4dce81.jpg) ![](RackMultipart20210911-4-hobine_html_9dc796299dc508f5.jpg)

![](RackMultipart20210911-4-hobine_html_efc3793ee5372cfa.jpg) ![](RackMultipart20210911-4-hobine_html_eb4fc4b38f8f1ca5.jpg)

![](RackMultipart20210911-4-hobine_html_77a63b9197b98bd7.jpg) ![](RackMultipart20210911-4-hobine_html_240343a968bfa9f0.jpg)

**Devices:**

It contains several different control features to dontrol particular device.

Feature 1) user can turn on /off ,can choose modes to set , can change Temperature in deg C or deg F,

**2) main page**

**3) light on / off page**

![](RackMultipart20210911-4-hobine_html_b24941d1a08429ec.jpg)

**4) Advance Message 5) Logging page**

![](RackMultipart20210911-4-hobine_html_cfe0744d45303dfd.jpg) ![](RackMultipart20210911-4-hobine_html_61285096f75a951e.jpg)
