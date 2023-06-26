import { frontendURL } from '../../../../helper/URLHelper';

const calendar = accountId => ({
  parentNav: 'calendar',
  routes: ['calendar_events', 'calendar_settings'],
  menuItems: [
    {
      key: 'calendar',
      icon: 'arrow-swap',
      label: 'CALENDAR',
      hasSubMenu: false,
      toState: frontendURL(`accounts/${accountId}/calendar/events`),
      toStateName: 'calendar_events',
    },
    {
      key: 'calendarSettings',
      icon: 'sound-source',
      label: 'CALENDAR_SETTINGS',
      hasSubMenu: false,
      toState: frontendURL(`accounts/${accountId}/calendar/settings`),
      toStateName: 'calendar_settings',
    },
  ],
});

export default calendar;
