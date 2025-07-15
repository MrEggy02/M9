import { io } from "socket.io-client";
import { calLatLon } from "./latlon.js";

// "id": "1d25faa3-efae-4cbf-95ba-2fd1dab99e69",
// "firstName": "cernuus",
// "lastName": "volva",
// "phoneNumber": "2055554445",
const token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IitEM1R2WlhzS1lENE03RWpYTzZ6bjhkZmpsNTcvb2t4MENUSWN2bDdpTWFlalhFT0JWWTdkY3Q4ZUFuME5WREE4NFB4WkE9PSIsInR5cGUiOiJ2Q3FFK21XUFlEZlJVdnRhdVkvWDRlU2t2UkE9IiwiZXgiOjYsImlhdCI6MTc1MTcyNTYyOSwiZXhwIjoxNzgzMjYxNjI5fQ.-84vWcUyGspG_CMvmAFaKoeVRway96QHtNd1sY8oGDU";

const socket = io("http://localhost:5000", {
    auth: {
        token,
    },
});

socket.on("connected", (data) => {
    console.log(data.message); // "You are connected!"
});

setTimeout(() => {
    socket.emit("ping");
}, 3000);

socket.on("pong", (data) => {
    console.log("pong received at");
    console.table(data);
});

export const SOCKET_EVENTS = {
    DRIVER_UPDATE_POSITION: "driver-update-position",
    DRIVER_CHOOSE_DRIVER: "driver-choose-driver",
    DRIVER_CONFIRM_ORDER: "driver-confirm-order",
    CUSTOMER_CONFIRM_ORDER: "customer-confirm-order",
    DRIVER_CANCEL_ORDER: "driver-cancel-order",
    DRIVER_CURRENT_POSITION: "driver-current-position",
    DRIVER_POSITION: "driver-position",
    USER_POSITION: "user-position",
    DRIVER_ORDER: "driver-order",
    DRIVER_LIST: "driver-list",
    USER_UPDATE_POSITION: "user-update-position",
    USER_SURVEY_DRIVER: "user-survey-driver",
    CHAT_MESSAGE: "chat-message",
    ORDER: "order",
    ORDER_COMPLETE: "order-complete",
};

const coordinates = [
    [102.65845151024888, 18.02970193761405],
    [102.6580219049174, 18.029734618417265],
    [102.65733453638546, 18.029914362725236],
    [102.65681900998845, 18.02993070310835],
    [102.65611445724261, 18.030110447216117],
    [102.65566766742802, 18.030143128389753],
    [102.6550266634182, 18.03028648495159],
    [102.6545283212331, 18.030400867356136],
    [102.65390968955472, 18.030466228696056],
    [102.65342853158359, 18.03058061098372],
    [102.65299892615172, 18.030645972487378],
    [102.65260251820331, 18.030756548000383],
    [102.65225883393737, 18.03080556890876],
    [102.65193233388521, 18.03082190920921],
    [102.65174330753831, 18.030658506142615],
    [102.65176049175227, 18.030446081929426],
    [102.65176049175227, 18.030233657459917],
    [102.65165738647079, 18.029988551984005],
    [102.65172612332441, 18.0296944249626],
    [102.65164020225893, 18.02936761658441],
    [102.65165738647079, 18.02922055261685],
    [102.65160583383113, 18.029073488525455],
    [102.65157146540531, 18.028844721918063],
    [102.65158864961927, 18.028664976517945],
    [102.65162301804503, 18.028436209378683],
    [102.65158864961927, 18.028207441943124],
    [102.65160583383113, 18.02801135533248],
    [102.65160583383113, 18.027864290231918],
    [102.65162301804503, 18.027700884419872],
    [102.65160583383113, 18.02753747845611],
    [102.65155428119141, 18.027259687969504],
    [102.65162301801297, 18.027079940959638],
    [102.65161197547178, 18.026825510437405],
    [102.65162915968574, 18.02654771882841],
    [102.65157760704602, 18.026335289654753],
    [102.65159479125793, 18.026024815785405],
    [102.65159479122457, 18.025730682139354],
    [102.65169789650395, 18.025534592771123],
    [102.65156042279881, 18.02520777667081],
    [102.65159161553976, 18.024981767533134],
    [102.65159161553976, 18.024785677329902],
    [102.6515572471119, 18.024491541616086],
    [102.6515744313258, 18.024311791771595],
    [102.6515744313258, 18.024066678051014],
    [102.65159161553976, 18.02387058682868],
    [102.65154006290004, 18.023641813460827],
    [102.65150569447218, 18.023413039794747],
    [102.65147132604642, 18.023167924824108],
    [102.65147132604642, 18.022922809511286],
    [102.65140258919274, 18.02264501174419],
    [102.65140258919274, 18.022334531368926],
    [102.65131666812732, 18.022024050446376],
    [102.6512651154876, 18.021746251261476],
    [102.65119637863404, 18.02145211047082],
    [102.65114482599432, 18.021092604393417],
    [102.6510589049268, 18.020831144965868],
    [102.65100735228714, 18.020520661392922],
    [102.65097298386132, 18.020226518555376],
    [102.6509042473586, 18.019899692706232],
    [102.65088706314464, 18.019736279503093],
    [102.65083551050498, 18.019507500764576],
    [102.65083551050498, 18.019246038985017],
    [102.65066366837198, 18.01898457681726],
    [102.65069803679773, 18.018723114260453],
    [102.6505777473044, 18.018461651316557],
    [102.65049182623898, 18.01815116356667],
    [102.65045745781316, 18.017889699773733],
    [102.65042308938536, 18.01767726015609],
    [102.65028561568016, 18.01730140482023],
    [102.6502340630405, 18.017105306065446],
    [102.65013095775902, 18.0168765239098],
    [102.65001066826778, 18.016566033365052],
    [102.64989037877444, 18.016271883923594],
    [102.64982164192088, 18.015928708954704],
    [102.6497529050672, 18.01561821674038],
    [102.64964979978788, 18.015258698755076],
    [102.64952951029454, 18.0149645471309],
    [102.64944358922907, 18.014588686008395],
    [102.64925456288216, 18.01427819143146],
    [102.64906553653532, 18.013951354445],
    [102.64896243125588, 18.01362451685125],
    [102.64867029963165, 18.01315060126403],
    [102.6487390365736, 18.01292181744995],
    [102.64870466814784, 18.012644003910452],
    [102.64849845766412, 18.012317163608117],
    [102.64846408929884, 18.011973980707097],
    [102.6483266155937, 18.011630797366976],
    [102.64822351031222, 18.01130395546889],
    [102.64808603660703, 18.010977112964568],
    [102.64794856289984, 18.010666612024608],
    [102.64787982608624, 18.010388794871815],
    [102.64779390502082, 18.010078292895244],
    [102.64763924710167, 18.009718763606458],
    [102.64750177339442, 18.009457287299938],
    [102.647415852329, 18.00901604515309],
    [102.64727837864473, 18.008656513691108],
    [102.64703779965811, 18.008264296721876],
    [102.64686595752505, 18.00783939402004],
    [102.64664256275239, 18.00749620262856],
    [102.64647072061939, 18.007153010567848],
    [102.64633324691425, 18.00672810518705],
    [102.64607548361988, 18.0063031987342],
    [102.645951780068, 18.005750978849534],
    [102.64586585900042, 18.005293384757238],
    [102.6456424642277, 18.00493384570919],
    [102.64557372737414, 18.004606991392123],
    [102.64533314838962, 18.004263793707324],
    [102.64521285886013, 18.00382253856054],
    [102.64499249920078, 18.003392828797942],
    [102.6448893938184, 18.0029842572074],
    [102.64466112357553, 18.002601415540852],
];

const updateDriverPos = () => {
    let { lon, lat } = coordinates[0];
    let count = 0;
    console.log(`📌📌💢 driver update position ==> `);
    setInterval(() => {
        const result = coordinates[count];
        if (!result) return console.log(` ==> 🚩 coordinates out`);
        lat = result[1];
        lon = result[0];
        socket.emit(SOCKET_EVENTS.DRIVER_UPDATE_POSITION, {
            lat,
            lon,
        });
        count++;
    }, 3500);
};

// updateDriverPos();

// 1 emit position
// emit
// update your position driver
socket.emit(SOCKET_EVENTS.DRIVER_UPDATE_POSITION, {
    lat: 18.0297955,
    lon: 102.6584334,
});

// 2 customer confirm order
// on
// handler order when customer confirm order and choose your driver
socket.on(SOCKET_EVENTS.CUSTOMER_CONFIRM_ORDER, (data) => {
    console.log("📌 received customer-confirm-order: ");
    console.log(JSON.stringify(data, null, 4));
});

// 3 order list to choose
// on
// handler order when customer confirm order and choose your driver
socket.on(SOCKET_EVENTS.ORDER, (data) => {
    console.log("📌 received order ");
    console.log(JSON.stringify(data, null, 4));
    const example = {
        id: "cbe7330b-538c-4042-8aaa-9c5b4f8b747e",
        uid: "20250618AFZE6PQKP",
        userId: "cae49003-3319-41f3-a44a-1d7e264c6314",
        driverId: null,
        vehicleId: null,
        serviceId: "f6bb1378-3301-4fdf-a2d5-7598e90e1483",
        pickupLocation: '{"lat":17.980376,"lon":102.622863}',
        pickupPlace: "ttt",
        destination: '{"lat":17.973124,"lon":102.62029}',
        destinationPlace: "yygvh",
        distance: 15,
        price: 500000,
        estimateDurationMinute: 30,
        arriveAt: null,
        startAt: null,
        orderType: "createdBySelf",
        carTypeId: "da889208-5b23-47b7-8a37-fb2d8624450d",
        paymentType: "cash",
        refCode: null,
        status: "requested",
        isActive: true,
        createdAt: "2025-06-18T17:32:56.141Z",
        updatedAt: "2025-06-18T17:32:56.141Z",
        user: {
            id: "cae49003-3319-41f3-a44a-1d7e264c6314",
            firstName: "capitulus",
            lastName: "audeo",
            phoneNumber: "2055554448",
            email: "cat@gmail.com",
        },
    };
});

// 4 message from customer
// on
// handler =message fro customer
socket.on(SOCKET_EVENTS.CHAT_MESSAGE, (data) => {
    console.log("📌 received chat-message ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {
        id: "093db170-f4f4-4b2e-97b7-c0387aa45457",
        conversationId: "2afe4215-4399-40b5-9634-7d11bafd3000",
        senderId: "079981fc-2172-4573-915b-2c5e71da39c2",
        senderType: "user",
        content: "where are you",
        isRead: false,
        createdAt: "2025-06-16T15:57:00.037Z",
        updatedAt: "2025-06-16T15:57:00.037Z",
    };
});

// 5 user position
// on
// handler customer current position when active order
socket.on(SOCKET_EVENTS.USER_POSITION, (data) => {
    console.log("📌 received USER_POSITION ");
    console.log(JSON.stringify(data, null, 4));
    // const sampleData = {
    //     orderActive: {
    //         id: "str",
    //         userId: "str",
    //         driverId: "str",
    //         pickUp: { lat, lon },
    //         dropOut: { lat, lon },
    //         createdAt: "2025-06-16T15:57:00.037Z", // "date string iso format"
    //     },
    //     userPosition: { lat, lon },
    // };
});

// 📌 USER

// 6 emit current position when request order
// update current position in case active order order request order
socket.emit(SOCKET_EVENTS.USER_UPDATE_POSITION, {
    lat: 18.0309633,
    lon: 102.6518033,
});

// 7 driver list when request order
// on
// handler driver list when request driver
socket.on(SOCKET_EVENTS.DRIVER_LIST, (data) => {
    console.log("📌 received driver list: ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {
        id: "43a445cb-4333-4118-a046-b6786944af1c",
        uid: "EQMSP3B1Q",
        userId: "2abc7661-4156-403d-a57c-1a4f9c0d360c",
        avatar: null,
        status: "success",
        reviewCount: 0,
        star: 0,
        user: {
            id: "2abc7661-4156-403d-a57c-1a4f9c0d360c",
            firstName: "gamer",
            lastName: "goodgamer",
            phoneNumber: "2029822968",
            displayName: null,
            avatar: null,
        },
        vehicle: {
            driverId: "43a445cb-4333-4118-a046-b6786944af1c",
            carTypeId: "babd866d-ab86-46ab-b4d2-651a48608c3a",
            brand: "toyo",
            model: "toya",
            year: "2023",
            color: "black",
            plateNumber: "ab 9513",
        },
    };
});

// 8 driver position (lat, lon) when survey driver
// on
// handler driver when wile survey
socket.on(SOCKET_EVENTS.USER_SURVEY_DRIVER, (data) => {
    console.log("📌 received USER_SURVEY_DRIVER list: ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {
        id: "7ba7926f-c753-4140-8a32-c72cfd3e13ca",
        uid: "WYLKEP27U",
        carTypeId: "babd866d-ab86-46ab-b4d2-651a48608c3a",
        carTypeCode: "M9C-0002",
        carTypeName: "ລົດໄຟຟ້າ",
        lat: 18.032812217032077,
        lon: 102.67559098103442,
    };
});

// 9 chat message
// on
// handler message from driver
socket.on(SOCKET_EVENTS.CHAT_MESSAGE, (data) => {
    console.log("📌 received chat-message ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {
        id: "093db170-f4f4-4b2e-97b7-c0387aa45457",
        conversationId: "2afe4215-4399-40b5-9634-7d11bafd3000",
        senderId: "079981fc-2172-4573-915b-2c5e71da39c2",
        senderType: "user",
        content: "where are you",
        isRead: false,
        createdAt: "2025-06-16T15:57:00.037Z",
        updatedAt: "2025-06-16T15:57:00.037Z",
    };
});

// 10 driver position when order start
// on
// handler driver current position when active order
socket.on(SOCKET_EVENTS.DRIVER_POSITION, (data) => {
    console.log("📌 received DRIVER_POSITION ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {
        orderActive: {
            id: "08c5a840-1580-484c-b6c4-988474ab7e92",
            userId: "d8155ea9-c7c3-4fdd-b670-46d48d2ad206",
            driverId: "3ca25b87-1b4b-4010-91f0-b40fa47ee9c5",
            pickUp: {
                lat: 17.980376,
                lon: 102.622863,
            },
            dropOut: {
                lat: 17.973124,
                lon: 102.62029,
            },
            createdAt: "2025-06-23T16:52:29.893Z",
        },
        driverPosition: {
            lat: 17.98187797340999,
            lon: 102.62203332815653,
        },
    };
});

// 12 order complete
// on
// handler order complete
socket.on(SOCKET_EVENTS.ORDER_COMPLETE, (data) => {
    console.log("📌 received ORDER_COMPLETE ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {}; // cusPureOrder
});
