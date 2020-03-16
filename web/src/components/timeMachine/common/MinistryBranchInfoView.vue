<template>
  <v-layout column py-2>
    <v-layout v-if="!form.isNonMinistry">
      <v-flex md4>
        <div class="body-1">Ministry:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{ form.ministry.ministryName }}</div>
      </v-flex>
    </v-layout>

    <v-layout v-if="form.isNonMinistry">
      <v-flex md4>
        <div class="body-1">Non-Ministry:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{ form.nonMinistryName }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Branch:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{ form.orgDivision }}</div>
      </v-flex>
    </v-layout>
    <v-flex xs12>
      <generic-contact-info-view :contact="form"></generic-contact-info-view>
    </v-flex>
    <v-flex xs12 pt-2 v-if="!form.isNonMinistry">
      <project-finance-info-view :financeInfo="form"></project-finance-info-view>
    </v-flex>
  </v-layout>
</template>

<script>
import MinistryDto from '@/domain/models/Ministry.dto';
import ProjectFinanceInfoView from '../projects/ProjectFinanceInfoView.vue';
import GenericContactInfoView from './GenericContactInfoView.vue';

export default {
  components: {
    ProjectFinanceInfoView,
    GenericContactInfoView,
  },
  props: {
    ministry: Object,
  },
  data() {
    const form = Object.assign({}, this.$props.ministry);
    const inputMinistry = form.ministry || null;
    if (!inputMinistry) {
      form.ministry = new MinistryDto();
    }
    return {
      form: { ...form },
    };
  },
  watch: {
    ministry(value) {
      this.form = value;
      const inputMinistry = this.form.ministry || null;
      if (!inputMinistry) {
        this.form.ministry = new MinistryDto();
      }
    },
  },
};
</script>
