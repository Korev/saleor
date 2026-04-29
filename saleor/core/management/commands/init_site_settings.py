from django.contrib.sites.models import Site
from django.core.management.base import BaseCommand

from saleor.site.models import SiteSettings


class Command(BaseCommand):
    help = "Create SiteSettings for the current site if missing."

    def handle(self, *args, **options):
        site, _ = Site.objects.get_or_create(
            id=1, defaults={"domain": "localhost", "name": "Saleor"}
        )
        _, created = SiteSettings.objects.get_or_create(site=site)
        if created:
            self.stdout.write("SiteSettings created.")
        else:
            self.stdout.write("SiteSettings already exist.")
