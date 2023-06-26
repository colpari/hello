/* eslint arrow-body-style: 0 */
import CalendarView from './CalendarView';
import { frontendURL } from '../../../helper/URLHelper';

export default {
  routes: [
    {
      path: frontendURL('accounts/:accountId/calendar'),
      name: 'hello_calendar',
      roles: ['administrator', 'agent'],
      component: CalendarView,
      props: () => {
        return { 'calendar_url' : 'http://192.168.178.84:3000/bookings/upcoming' };
      },
      data: () => {
        return { 'calendar_url' : 'http://192.168.178.84:3000/bookings/upcoming' };
      },
    },
  ],
};
