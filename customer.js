import { io } from "socket.io-client";
import { calLatLon } from "./latlon.js";

// 📌📌💢 user.id ==>  8bc6679b-b59a-49ce-81ef-59e686efa752
// 📌📌💢 user.username ==>  fish

const token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IittelN1TVRvS1lQNFlPTjJBZTZ6ejVVS2pnWjVxOXd4MG51ZmNxdDUyWjJXMFNVQUs2MDFQeXY5RVc0VHd6OXRQZXRlVXc9PSIsInR5cGUiOiJ2Q3FFK21XUFlEZlJVdnRhdVkvWDRlU2t2UkE9IiwiZXgiOjMsImlhdCI6MTc1MTcyNTUxMywiZXhwIjoxNzgzMjYxNTEzfQ.-RH50NO_VlPtMgiHG0BYHu0ijcbbWE0p6D7zVq0nIo4";

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
    console.log("pong received at", new Date(data.time));
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
    CHAT_MESSAGE: "chat-message",
    ORDER: "order",
    ORDER_COMPLETE: "order-complete",
    USER_SURVEY_DRIVER: "user-survey-driver",
};

const updateCustomerPos = () => {
    let { lat, lon } = calLatLon(17.9808, 102.6209);
    setInterval(() => {
        const result = calLatLon(lat, lon);
        lat = result.lat;
        lon = result.lon;
        socket.emit(SOCKET_EVENTS.USER_UPDATE_POSITION, {
            lat,
            lon,
        });
    }, 3500);
};

// updateCustomerPos();

// update current position in case active order order request order
socket.emit(SOCKET_EVENTS.USER_UPDATE_POSITION, {
    lat: 17.9808,
    lon: 102.6209,
});

// on
//  handler driver list when request driver
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

// on
//  handler order complete
socket.on(SOCKET_EVENTS.ORDER_COMPLETE, (data) => {
    console.log("📌 received ORDER_COMPLETE ");
    console.log(JSON.stringify(data, null, 4));
    const sampleData = {}; // cusPureOrder
});
