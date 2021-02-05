<template>
    <v-card
        :color="$attrs.color"
        dark
        class="p-2"
        >
        <div class="d-flex flex-no-wrap justify-space-between">
            <div>
            <v-card-title
                class="headline"
                v-text="$attrs.message"
                dense
            ></v-card-title>

            <v-card-subtitle v-text="$attrs.user"></v-card-subtitle>
            </div>

            <v-avatar
            class="ma-3"
            tile
            >
                <v-icon v-if="$attrs.client === true" large light>mdi-account-circle-outline</v-icon>
                <v-icon v-else-if="$attrs.client === false" large light>mdi-robot-outline</v-icon>
                <v-icon v-else large light>mdi-alert-cicle-outline</v-icon>
            </v-avatar>
        </div>
    </v-card>
</template>

<script>
export default {
    data: () => ({  
        client: false,
        message: "DEFAULT MESSAGE",
        user: "Bot  ",
        color: "#222222"
    }),
}
</script>