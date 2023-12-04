from os import name
from flask import render_template, redirect, request, jsonify, flash, session
from flask.helpers import url_for
from app.controller.admin.controller import login_is_required
from app.controller.subjects.forms import subjectForm
import app.models.subjectModel as subjectModel
from . import subject

def subject_route(rule, **options):
    def decorator(f):
        @subject.route(rule, **options)
        @login_is_required  
        def wrapper(*args, **kwargs):
            return f(*args, **kwargs)
        return wrapper
    return decorator


@subject.route("/subjects")
def index():
    subjectInfo = subjectModel.Subjects.all()
    sectionInfo = subjectModel.Subjects.refer_section()
    handlerInfo = subjectModel.Subjects.refer_handler()
    flash_message = session.pop('flash_message', None)
    return render_template("subjectList.html", subjectInfo=subjectInfo, sectionInfo=sectionInfo, handlerInfo=handlerInfo, flash_message=flash_message)

@subject.route("/subjects/create", methods=['POST','GET'])
def create_subject():
    form = subjectForm(request.form)
    if request.method == "POST" and form.validate():
        code=form.subjectCode.data
        section=form.section.data
        description=form.description.data
        credits=form.credits.data
        handler=form.handler.data
        subjects = subjectModel.Subjects(code, section, description, credits, handler)
        existing_subject = subjectModel.Subjects.exists(code)

        if existing_subject:
            result = subjects.add_section()
            flash_message = {"type": "success", "message": f"Successfully Added Subject!"}
            session['flash_message'] = flash_message
            return redirect(url_for(".index", message=flash_message))
        else:
            result = subjects.add()
            if "success" in result:
                credentials_message = f"Subject Code: <strong>{code}</strong><br>Section: <strong>{section}</strong><br> Description: <strong>{description}</strong><br>Credits: <strong>{credits}</strong><br>Handler: <strong>{handler}</strong>"
                flash_message = {"type": "success", "message": f"Subject created successfully - {credentials_message}"}
                session['flash_message'] = flash_message
            else:
                flash_message = {"type": "danger", "message": f"Failed to create Subject: {result}"}
                session['flash_message'] = flash_message
            return redirect(url_for(".index", message=flash_message))
    return redirect(url_for(".index"))

@subject.route("/subjects/delete/<string:subjectCode>/<string:section>/<string:handler>", methods=["POST"])
def delete_subject(subjectCode, section, handler):
    try:
        existing_subject = subjectModel.Subjects.exists_many(subjectCode)
        if existing_subject > 1 :
            result = subjectModel.Subjects.delete_section(subjectCode, section, handler)
            flash_message = {"type": "success", "message": f"Successfully Deleted Section: {result}"}
            session['flash_message'] = flash_message
            return redirect(url_for(".index", message=flash_message))
        else:
            result = subjectModel.Subjects.delete(subjectCode, section, handler)
            return jsonify({'success': result == 'Subject deleted successfully'})
    except Exception as e:
        print(e)
        return jsonify({'success': False, 'error': str(e)})
    
@subject.route("/subjects/update", methods=["POST"])
def update_subject():
    if request.method == "POST":
        subjectCode = request.form["subjectCode"]
        old_subjectCode = request.form["editCodeInputHidden"]
        section = request.form["section"]
        old_sectionCode = request.form["editSectionInputHidden"]
        description = request.form["description"]
        credits = request.form["credits"]
        handler = request.form["handler"]
        old_handlerCode = request.form["editHandlerInput"]

        result = subjectModel.Subjects.update(subjectCode, old_subjectCode, section, old_sectionCode, description, credits, handler, old_handlerCode)
        if "success" in result:
            credentials_message = f"Subject Code: <strong>{subjectCode}</strong><br>Section: <strong>{section}</strong><br> Description: <strong>{description}</strong><br>Credits: <strong>{credits}</strong><br>Handler: <strong>{handler}</strong>"
            flash_message = {"type": "success", "message": f"Subject Edited successfully - {credentials_message}"}
            session['flash_message'] = flash_message
        else:
            flash_message = {"type": "danger", "message": f"Failed to Edit Subject: {result}"}
            session['flash_message'] = flash_message
        return redirect(url_for(".index", message=flash_message))
    return redirect(url_for(".index"))