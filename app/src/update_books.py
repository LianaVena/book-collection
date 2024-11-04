import logging
import requests
from app import headers
from ..src import get_data
from ..src.get_books import get_pages

logger = logging.getLogger(__name__)


def update_page(page_id, data):
    url = f"https://api.notion.com/v1/pages/{page_id}"
    payload = {"properties": data}
    result = requests.patch(url, json=payload, headers=headers)
    logger.info(str(result.status_code) + " " + result.reason)
    return result


def get_update_page_data_dict(isbn):
    if _check_duplicate(isbn):
        logger.info("ISBN already in database")
        return

    result = dict()
    get_data.init(isbn)

    result["ISBN"] = _get_text(isbn)
    cover_url = get_data.get_cover_url()
    if cover_url != None:
        cover = {
            "type": "external",
            "external": {"url": cover_url},
        }
        result["cover"] = cover
        result["icon"] = cover
    _set_rich_text(result, "Title", get_data.get_title())
    _set_rich_text(result, "Subtitle", get_data.get_subtitle())
    _set_multi_select(result, "Author", get_data.get_authors())
    contributors = get_data.get_contributors()
    _set_multi_select(result, "Editor", get_data.get_editors(contributors))
    _set_multi_select(result, "Illustrator", get_data.get_illustrators(contributors))
    _set_multi_select(result, "Translator", get_data.get_translators(contributors))
    _set_multi_select(result, "Publisher", get_data.get_publishers())
    _set_multi_select(result, "Imprint", get_data.get_imprints())
    _set_multi_select(result, "Series", get_data.get_series())
    _set_multi_select(result, "Format", get_data.get_formats())
    _set_multi_select(result, "Genres", get_data.get_genres())
    _set_number(result, "First Pub. Year", get_data.get_first_pub_year())
    _set_number(result, "Publication Year", get_data.get_pub_year())
    _set_multi_select(result, "Setting Places", get_data.get_setting_places())
    _set_multi_select(result, "Setting Times", get_data.get_setting_times())
    _set_multi_select(result, "Language", get_data.get_languages())
    _set_number(result, "Pages", get_data.get_pages())
    _set_number(result, "Weight", get_data.get_weight())
    _set_number(result, "Width", get_data.get_width())
    _set_number(result, "Height", get_data.get_height())
    _set_number(result, "Spine Width", get_data.get_spine_width())
    result["Data status"] = {"select": {"name": "To be edited"}}
    return result


def _check_duplicate(isbn):
    data = get_pages({"filter": {"property": "ISBN", "title": {"equals": isbn}}})
    return len(data["results"]) > 0


def _get_text(text):
    return {"title": [{"text": {"content": text}}]}


def _get_rich_text(text):
    return {"rich_text": [{"text": {"content": text}}]}


def _set_rich_text(result, name, text):
    if text != None:
        result[name] = _get_rich_text(text)


def _get_number(num):
    return {"number": int(num)}


def _set_number(result, name, num):
    if str(num).isdigit() == True:
        result[name] = _get_number(num)


def _get_multi_select(list):
    return {"multi_select": [{"name": name} for name in list]}


def _set_multi_select(result, name, list):
    if list != None:
        result[name] = _get_multi_select(list)
