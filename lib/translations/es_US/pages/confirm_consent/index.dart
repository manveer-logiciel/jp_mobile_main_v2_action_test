import '../../../../core/constants/urls.dart';

class EsUsConfirmConsentMessageTranslations {
  static Map<String, String> strings = {
    "confirm_consent_message": "¿Qué tipo de mensaje enviarás al consumidor ahora o en el futuro?",
    "no_messaging": "Sin mensajería",
    "no_messaging_consent_message": "No tengo intención de comunicarme mediante mensajes con este cliente, o él ha solicitado específicamente no ser contactado.",
    "transactional_messaging": "Mensajería transaccional",
    "transactional_messaging_consent_message": "Deseo enviar al cliente mensajes transaccionales(${Urls.transactionalTextingURL}) para comunicarme sobre un trabajo que está siendo estimado o en progreso.",
    "promotional_messaging": "Mensajería promocional",
    "promotional_messaging_consent_message": "Además de los mensajes transaccionales(${Urls.transactionalTextingURL}), deseo enviar al cliente mensajes promocionales(${Urls.promotionalTextingURL}) para promocionar mi negocio, nuestras ofertas, o cualquier otra cosa no relacionada directamente con la transacción para la cual originalmente consintió ser contactado.",
    "confirm_express_consent": "Confirmar consentimiento expreso",
    "express_consent_conformation_message": "Confirma que has obtenido “consentimiento expreso” para contactar a este cliente con fines de mensajería transaccional, ya que proporcionó voluntariamente su número de teléfono de una de las siguientes maneras:",
    "express_consent_conformation_message_statement_1": "Por teléfono o en persona a un miembro de tu equipo",
    "express_consent_conformation_message_statement_2": "A través de un formulario de contacto (impreso o en tu sitio web)",
    "express_consent_conformation_message_statement_3": "Mediante una comunicación por correo electrónico",
    "express_consent_conformation_checkbox_message": "Confirmo que este consumidor proporcionó “consentimiento expreso” para\nser contactado",
    "remove_consent": "Eliminar consentimiento",
    "remove_consent_message": "¿Estás seguro de que deseas indicar que este cliente no ha dado su consentimiento para ser contactado? No podrás enviarle ningún mensaje a menos que obtengas su consentimiento nuevamente.",
    "remove_consent_checkbox_message": "Entiendo que no puedo enviar mensajes a este cliente\nsin su consentimiento",
    "remove_express_consent": "Eliminar consentimiento expreso por escrito",
    "remove_express_consent_message": "¿Estás seguro de que deseas eliminar el consentimiento expreso por escrito de este cliente? No podrás enviarle mensajes promocionales en el futuro a menos que obtengas nuevamente su consentimiento por escrito.",
    "remove_express_consent_checkbox_message": "Entiendo que no puedo enviar mensajes promocionales a este\ncliente sin su consentimiento expreso por escrito.",
    "no": "No",
  };
}