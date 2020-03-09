import * as Koa from 'koa';
import * as Router from 'koa-router';
import { 
  retrieveProjectIntakeCategory, 
  retrieveProjectIntakeCategoryById 
} from '../../../services/client/projectIntakeCategory.service';
import { authorize } from '../../../services/common/authorize.service';

export const getProjectIntakeCategory = async (ctx: Koa.Context) => {
  try {
    const projectIntakeCategories = await retrieveProjectIntakeCategory();
    ctx.body = projectIntakeCategories;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getProjectIntakeCategoryById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveProjectIntakeCategoryById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/project-intake-category'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getProjectIntakeCategory);
router.get('/:id', authorize, getProjectIntakeCategoryById);

export default router;
