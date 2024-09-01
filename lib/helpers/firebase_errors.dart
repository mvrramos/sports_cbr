String getErrorString(String code) {
  switch (code) {
    case 'weak-password':
      return 'Sua senha é muito fraca.';
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
    case 'email-already-in-use':
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'invalid-credential':
      return 'Credencial inválida.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    case 'user-not-found':
      return 'Não há usuário com este e-mail.';
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
    case 'too-many-requests':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'operation-not-allowed':
      return 'Operação não permitida.';
    case 'account-exists-with-different-credential':
      return 'Conta já existe com credenciais diferentes.';
    case 'requires-recent-login':
      return 'Reautenticação necessária. Por favor, faça login novamente.';
    case 'credential-already-in-use':
      return 'Esta credencial já está em uso por outra conta.';
    case 'invalid-verification-code':
      return 'O código de verificação é inválido.';
    case 'invalid-verification-id':
      return 'O ID de verificação é inválido.';
    default:
      return 'Um erro indefinido ocorreu.';
  }
}
