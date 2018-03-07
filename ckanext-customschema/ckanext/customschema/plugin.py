import ckan.plugins as p
import ckan.plugins.toolkit as tk
from ckan.lib.plugins import DefaultTranslation
import datetime

def convert_to_json_if_datetime(date, context):
    if isinstance(date, datetime.datetime):
        return date.isoformat()

    return date

class CustomschemaPlugin(p.SingletonPlugin, DefaultTranslation, tk.DefaultDatasetForm):
    p.implements(p.IDatasetForm)
    p.implements(p.ITranslation)
    p.implements(p.IConfigurer)


    def _modify_schema(self, schema):
        schema.update({
            'start_date': [tk.get_validator('ignore_missing'),
                           tk.get_validator('isodate'),
                           tk.get_converter('convert_to_extras')],
            'end_date': [tk.get_validator('ignore_missing'),
                         tk.get_validator('isodate'),
                         tk.get_converter('convert_to_extras')],
            'last_update_date': [tk.get_validator('ignore_missing'),
                                 tk.get_validator('isodate'),
                                 tk.get_converter('convert_to_extras')],
        })
        return schema

    def create_package_schema(self):
        schema = super(CustomschemaPlugin, self).create_package_schema()
        schema = self._modify_schema(schema)
        return schema

    def update_package_schema(self):
        schema = super(CustomschemaPlugin, self).update_package_schema()
        schema = self._modify_schema(schema)
        return schema

    def show_package_schema(self):
        schema = super(CustomschemaPlugin, self).show_package_schema()
        schema.update({
            'start_date': [tk.get_converter('convert_from_extras'),
                           # tk.get_validator('isodate'),
                           tk.get_validator('ignore_missing')],
            'end_date': [tk.get_converter('convert_from_extras'),
                         # tk.get_validator('isodate'),
                         tk.get_validator('ignore_missing')],
            'last_update_date': [tk.get_converter('convert_from_extras'),
                                 # tk.get_validator('isodate'),
                                 tk.get_validator('ignore_missing')],
        })
        return schema

    def is_fallback(self):
        # Return True to register this plugin as the default handler for
        # package types not handled by any other IDatasetForm plugin.
        return True

    def package_types(self):
        # This plugin doesn't handle any special package types, it just
        # registers itself as the default (above).
        return []

    def update_config(self, config):
        # Add this plugin's templates dir to CKAN's extra_template_paths, so
        # that CKAN will use this plugin's custom templates.
        tk.add_template_directory(config, 'templates')

    # def i18n_directory(self):
    #     return super(CustomschemaPlugin, self).i18n_directory()

    # def i18n_locales(self):
    #     return ['zh_TW,', 'zh_CN', 'en']

    # def i18n_domain(self):
    #     return super(CustomschemaPlugin, self).i18n_domain()
