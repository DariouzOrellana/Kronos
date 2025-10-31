package com.masterKey.kronos.config;

import com.masterKey.kronos.model.Usuario;
import com.masterKey.kronos.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Optional;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public CustomAuthenticationProvider(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName().toUpperCase();
        String rawPassword = authentication.getCredentials().toString();

        Optional<Usuario> userOpt = usuarioRepository.findByUsername(username);
        if (userOpt.isEmpty()) {
            throw new BadCredentialsException("Usuario o contraseña inválidos");
        }
        Usuario user = userOpt.get();

        // Con NoOpPasswordEncoder, compara texto plano. Si luego usas hash, cambia a passwordEncoder.matches
        boolean matches = passwordEncoder.matches(rawPassword, user.getPassword());
        if (!matches) {
            throw new BadCredentialsException("Usuario o contraseña inválidos");
        }

        String roleName = user.getRol() != null ? user.getRol().getNombreRol() : "USER";
        GrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + roleName);
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                username,
                user.getPassword(),
                Collections.singletonList(authority)
        );

        auth.setDetails(user);
        return auth;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
