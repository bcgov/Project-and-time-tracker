<template>
  <v-layout row wrap py-2>
    <v-form id="intake-review" ref="intakeReview" >
      
    </v-form>
  </v-layout>
</template>
<script>
import './intakeRisk.styl';

export default {
  components: {},
  props: {
    intakeValues: Array,
  },
  computed: {
    
  },
  data() {
    const form = Object.assign({}, this.$props.intakeValues);
    return {      
      form: { ...form },      
    };
  },
  watch: {},
  methods: {
   
  },
};
</script>
