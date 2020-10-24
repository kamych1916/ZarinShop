<template>
  <div class="container">
    <div>
      <b-dropdown id="dropdown-grouped" dropright  text="Dropdown with group" class="m-2">
        <b-dropdown-item-button>
          Non-grouped Item
        </b-dropdown-item-button>
        <b-dropdown-divider></b-dropdown-divider>
        <b-dropdown-group id="dropdown-group-1" header="Group 1">
          <b-dropdown-item-button>First Grouped item</b-dropdown-item-button>
          <b-dropdown-item-button>Second Grouped Item</b-dropdown-item-button>
        </b-dropdown-group>
        <b-dropdown-group id="dropdown-group-2" header="Group 2">
          <b-dropdown-item-button>First Grouped item</b-dropdown-item-button>
          <b-dropdown-item-button>Second Grouped Item</b-dropdown-item-button>
        </b-dropdown-group>
        <b-dropdown-divider></b-dropdown-divider>
        <b-dropdown-item-button>
          Another Non-grouped Item
        </b-dropdown-item-button>
      </b-dropdown>
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family:
    'Quicksand',
    'Source Sans Pro',
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    Roboto,
    'Helvetica Neue',
    Arial,
    sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}
</style>
